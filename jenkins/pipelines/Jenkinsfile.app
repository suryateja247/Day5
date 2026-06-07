@Library('enterprise-devops-platform') _

pipeline {
  agent {
    kubernetes {
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
    - name: docker
      image: docker:26-cli
      command: ['cat']
      tty: true
      volumeMounts:
        - name: docker-sock
          mountPath: /var/run/docker.sock
    - name: tools
      image: alpine/helm:3.15.4
      command: ['cat']
      tty: true
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
"""
    }
  }

  options {
    timestamps()
    ansiColor('xterm')
    buildDiscarder(logRotator(numToKeepStr: '50'))
    disableConcurrentBuilds()
  }

  parameters {
    string(name: 'APP_NAME', defaultValue: 'sample-app', description: 'Application name and image repository name')
    string(name: 'REGISTRY_URL', defaultValue: 'artifactory.example.com/docker-local', description: 'JFrog/Nexus Docker repository URL')
    string(name: 'NAMESPACE', defaultValue: 'sample-app', description: 'Kubernetes namespace')
    string(name: 'HELM_CHART', defaultValue: 'kubernetes/helm/app-chart', description: 'Path to Helm chart')
    string(name: 'HELM_RELEASE', defaultValue: 'sample-app', description: 'Helm release name')
    choice(name: 'ENVIRONMENT', choices: ['dev', 'qa', 'stage', 'prod'], description: 'Target environment')
    choice(name: 'DEPLOY_TARGET', choices: ['kubernetes', 'ansible', 'both'], description: 'Deployment mechanism')
    string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS region')
    string(name: 'AWS_ROLE_ARN', defaultValue: '', description: 'Optional role Jenkins assumes for the target environment')
    string(name: 'EKS_CLUSTER', defaultValue: '', description: 'Target EKS cluster name')
    booleanParam(name: 'RUN_TERRAFORM', defaultValue: false, description: 'Run app infrastructure Terraform before deploy')
    string(name: 'TERRAFORM_DIR', defaultValue: 'terraform/environments/dev', description: 'Terraform stack for app/platform changes')
    string(name: 'TEST_COMMAND', defaultValue: 'echo no test command configured', description: 'Test command to run before image build')
    string(name: 'SMOKE_TEST_COMMAND', defaultValue: 'kubectl rollout status deployment/sample-app -n sample-app --timeout=180s', description: 'Smoke test command')
  }

  environment {
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    ARTIFACT_CREDENTIALS_ID = 'artifact-registry-creds'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Test') {
      steps {
        sh params.TEST_COMMAND
      }
    }

    stage('Build Scan Push Image') {
      steps {
        container('docker') {
          dockerBuildPush(
            appName: params.APP_NAME,
            registryUrl: params.REGISTRY_URL,
            imageTag: env.IMAGE_TAG,
            credentialsId: env.ARTIFACT_CREDENTIALS_ID,
            dockerfile: 'Dockerfile',
            contextDir: '.'
          )
        }
      }
    }

    stage('Terraform Plan Apply') {
      when {
        expression { return params.RUN_TERRAFORM }
      }
      steps {
        terraformPipeline(
          terraformDir: params.TERRAFORM_DIR,
          action: 'apply',
          awsRoleArn: params.AWS_ROLE_ARN,
          awsRegion: params.AWS_REGION
        )
      }
    }

    stage('Deploy Kubernetes') {
      when {
        expression { return params.DEPLOY_TARGET == 'kubernetes' || params.DEPLOY_TARGET == 'both' }
      }
      steps {
        kubernetesDeploy(
          awsRoleArn: params.AWS_ROLE_ARN,
          awsRegion: params.AWS_REGION,
          eksCluster: params.EKS_CLUSTER,
          namespace: params.NAMESPACE,
          releaseName: params.HELM_RELEASE,
          chartPath: params.HELM_CHART,
          imageRepository: "${params.REGISTRY_URL}/${params.APP_NAME}",
          imageTag: env.IMAGE_TAG
        )
      }
    }

    stage('Deploy Ansible') {
      when {
        expression { return params.DEPLOY_TARGET == 'ansible' || params.DEPLOY_TARGET == 'both' }
      }
      steps {
        ansibleDeploy(
          inventory: 'ansible/inventories/aws_ec2.yml',
          playbook: 'ansible/playbooks/deploy-artifact.yml',
          appName: params.APP_NAME,
          appVersion: env.IMAGE_TAG,
          artifactUrl: "${params.REGISTRY_URL}/${params.APP_NAME}:${env.IMAGE_TAG}"
        )
      }
    }

    stage('Smoke Test') {
      steps {
        sh params.SMOKE_TEST_COMMAND
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: '**/tfplan, **/*.log', allowEmptyArchive: true
    }
    success {
      echo "Delivered ${params.APP_NAME}:${env.IMAGE_TAG} to ${params.ENVIRONMENT}"
    }
  }
}
