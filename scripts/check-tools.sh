#!/usr/bin/env bash
set -euo pipefail

required_tools=(
  aws
  terraform
  docker
  kubectl
  helm
  ansible-playbook
  git
)

missing=()

for tool in "${required_tools[@]}"; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    missing+=("$tool")
  fi
done

if [ "${#missing[@]}" -gt 0 ]; then
  printf 'Missing required tools:\n'
  printf '  - %s\n' "${missing[@]}"
  exit 1
fi

echo "All required tools are available."
