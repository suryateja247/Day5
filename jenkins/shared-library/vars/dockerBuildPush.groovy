def call(Map cfg = [:]) {
  String appName = cfg.appName ?: error('dockerBuildPush requires appName')
  String registryUrl = cfg.registryUrl ?: error('dockerBuildPush requires registryUrl')
  String imageTag = cfg.imageTag ?: env.BUILD_NUMBER
  String credentialsId = cfg.credentialsId ?: 'artifact-registry-creds'
  String dockerfile = cfg.dockerfile ?: 'Dockerfile'
  String contextDir = cfg.contextDir ?: '.'
  String image = "${registryUrl}/${appName}:${imageTag}"

  withCredentials([usernamePassword(
    credentialsId: credentialsId,
    usernameVariable: 'REGISTRY_USERNAME',
    passwordVariable: 'REGISTRY_PASSWORD'
  )]) {
    sh """
      set -euo pipefail
      echo "\$REGISTRY_PASSWORD" | docker login '${registryUrl}' -u "\$REGISTRY_USERNAME" --password-stdin
      docker build -f '${dockerfile}' -t '${image}' '${contextDir}'
      if command -v trivy >/dev/null 2>&1; then
        trivy image --exit-code 0 --severity HIGH,CRITICAL '${image}'
      fi
      docker push '${image}'
      if [ -n "\${GIT_COMMIT:-}" ]; then
        docker tag '${image}' '${registryUrl}/${appName}:'"\$GIT_COMMIT"
        docker push '${registryUrl}/${appName}:'"\$GIT_COMMIT"
      fi
    """
  }

  env.DELIVERED_IMAGE = image
  return image
}
