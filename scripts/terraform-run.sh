#!/usr/bin/env bash
set -euo pipefail

stack_dir="${1:?Usage: terraform-run.sh <stack-dir> <plan|apply|destroy|validate>}"
action="${2:-plan}"
backend_file="${BACKEND_CONFIG:-backend.hcl}"

cd "$stack_dir"

if [ -f "$backend_file" ]; then
  terraform init -backend-config="$backend_file"
else
  terraform init
fi

case "$action" in
  validate)
    terraform validate
    ;;
  plan)
    terraform plan -out=tfplan
    ;;
  apply)
    terraform plan -out=tfplan
    terraform apply tfplan
    ;;
  destroy)
    terraform plan -destroy -out=tfplan
    terraform apply tfplan
    ;;
  *)
    echo "Unsupported action: $action"
    exit 1
    ;;
esac
