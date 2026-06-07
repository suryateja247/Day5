def call(Map cfg = [:]) {
  String terraformDir = cfg.terraformDir ?: error('terraformPipeline requires terraformDir')
  String action = cfg.action ?: 'plan'
  String awsRoleArn = cfg.awsRoleArn ?: ''
  String awsRegion = cfg.awsRegion ?: 'ap-south-1'

  withEnv(["AWS_REGION=${awsRegion}", "AWS_DEFAULT_REGION=${awsRegion}"]) {
    if (awsRoleArn?.trim()) {
      sh """
        set -euo pipefail
        CREDS=\$(aws sts assume-role --role-arn '${awsRoleArn}' --role-session-name jenkins-terraform-${env.BUILD_NUMBER} --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text)
        export AWS_ACCESS_KEY_ID=\$(echo "\$CREDS" | awk '{print \$1}')
        export AWS_SECRET_ACCESS_KEY=\$(echo "\$CREDS" | awk '{print \$2}')
        export AWS_SESSION_TOKEN=\$(echo "\$CREDS" | awk '{print \$3}')
        cd '${terraformDir}'
        terraform init
        terraform validate
        if [ '${action}' = 'validate' ]; then exit 0; fi
        if [ '${action}' = 'plan' ]; then terraform plan -out=tfplan; exit 0; fi
        if [ '${action}' = 'apply' ]; then terraform plan -out=tfplan && terraform apply -auto-approve tfplan; exit 0; fi
        if [ '${action}' = 'destroy' ]; then terraform plan -destroy -out=tfplan && terraform apply -auto-approve tfplan; exit 0; fi
        echo 'Unsupported Terraform action: ${action}'
        exit 1
      """
    } else {
      sh """
        set -euo pipefail
        cd '${terraformDir}'
        terraform init
        terraform validate
        if [ '${action}' = 'validate' ]; then exit 0; fi
        if [ '${action}' = 'plan' ]; then terraform plan -out=tfplan; exit 0; fi
        if [ '${action}' = 'apply' ]; then terraform plan -out=tfplan && terraform apply -auto-approve tfplan; exit 0; fi
        if [ '${action}' = 'destroy' ]; then terraform plan -destroy -out=tfplan && terraform apply -auto-approve tfplan; exit 0; fi
        echo 'Unsupported Terraform action: ${action}'
        exit 1
      """
    }
  }
}
