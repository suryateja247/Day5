#!/usr/bin/env bash
set -euo pipefail

registry_url="${REGISTRY_URL:?Set REGISTRY_URL, for example artifactory.example.com/docker-local}"
image_name="${IMAGE_NAME:-jenkins-agent-tools}"
image_tag="${IMAGE_TAG:-latest}"
image="${registry_url}/${image_name}:${image_tag}"

if [ -n "${REGISTRY_USERNAME:-}" ] && [ -n "${REGISTRY_PASSWORD:-}" ]; then
  echo "$REGISTRY_PASSWORD" | docker login "$registry_url" -u "$REGISTRY_USERNAME" --password-stdin
fi

docker build -f jenkins/agent/Dockerfile -t "$image" .
docker push "$image"

echo "$image"
