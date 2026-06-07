#!/usr/bin/env bash
set -euo pipefail

app_name="${APP_NAME:?Set APP_NAME}"
registry_url="${REGISTRY_URL:?Set REGISTRY_URL, for example artifactory.example.com/docker-local}"
image_tag="${IMAGE_TAG:-${BUILD_NUMBER:-local}}"
dockerfile="${DOCKERFILE:-Dockerfile}"
context_dir="${CONTEXT_DIR:-.}"

image="${registry_url}/${app_name}:${image_tag}"

if [ -n "${REGISTRY_USERNAME:-}" ] && [ -n "${REGISTRY_PASSWORD:-}" ]; then
  echo "$REGISTRY_PASSWORD" | docker login "$registry_url" -u "$REGISTRY_USERNAME" --password-stdin
fi

docker build -f "$dockerfile" -t "$image" "$context_dir"

if command -v trivy >/dev/null 2>&1; then
  trivy image --exit-code "${TRIVY_EXIT_CODE:-0}" --severity HIGH,CRITICAL "$image"
fi

docker push "$image"

if [ -n "${GIT_COMMIT:-}" ]; then
  commit_image="${registry_url}/${app_name}:${GIT_COMMIT}"
  docker tag "$image" "$commit_image"
  docker push "$commit_image"
fi

echo "$image"
