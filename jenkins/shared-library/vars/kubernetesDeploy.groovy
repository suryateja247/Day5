def call(Map cfg = [:]) {
  String awsRoleArn = cfg.awsRoleArn ?: ''
  String awsRegion = cfg.awsRegion ?: 'ap-south-1'
  String eksCluster = cfg.eksCluster ?: error('kubernetesDeploy requires eksCluster')
  String namespace = cfg.namespace ?: 'default'
  String releaseName = cfg.releaseName ?: error('kubernetesDeploy requires releaseName')
  String chartPath = cfg.chartPath ?: error('kubernetesDeploy requires chartPath')
  String imageRepository = cfg.imageRepository ?: error('kubernetesDeploy requires imageRepository')
  String imageTag = cfg.imageTag ?: env.BUILD_NUMBER

  withEnv(["AWS_REGION=${awsRegion}", "AWS_DEFAULT_REGION=${awsRegion}"]) {
    String roleArg = awsRoleArn?.trim() ? "--role-arn '${awsRoleArn}'" : ''
    sh """
      set -euo pipefail
      aws eks update-kubeconfig --name '${eksCluster}' --region '${awsRegion}' ${roleArg}
      kubectl create namespace '${namespace}' --dry-run=client -o yaml | kubectl apply -f -
      helm upgrade --install '${releaseName}' '${chartPath}' \
        --namespace '${namespace}' \
        --set image.repository='${imageRepository}' \
        --set image.tag='${imageTag}' \
        --wait \
        --timeout 10m
      kubectl rollout status deployment/'${releaseName}' -n '${namespace}' --timeout=180s
    """
  }
}
