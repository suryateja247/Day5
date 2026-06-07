#!/usr/bin/env bash
set -euo pipefail

inventory="${ANSIBLE_INVENTORY:-ansible/inventories/aws_ec2.yml}"
playbook="${1:-ansible/playbooks/deploy-artifact.yml}"

ansible-playbook -i "$inventory" "$playbook" \
  -e "artifact_url=${ARTIFACT_URL:-}" \
  -e "app_name=${APP_NAME:-sample-app}" \
  -e "app_version=${APP_VERSION:-latest}"
