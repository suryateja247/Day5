def call(Map cfg = [:]) {
  String inventory = cfg.inventory ?: 'ansible/inventories/aws_ec2.yml'
  String playbook = cfg.playbook ?: error('ansibleDeploy requires playbook')
  String appName = cfg.appName ?: error('ansibleDeploy requires appName')
  String appVersion = cfg.appVersion ?: env.BUILD_NUMBER
  String artifactUrl = cfg.artifactUrl ?: ''

  sh """
    set -euo pipefail
    ansible-playbook -i '${inventory}' '${playbook}' \
      -e app_name='${appName}' \
      -e app_version='${appVersion}' \
      -e artifact_url='${artifactUrl}'
  """
}
