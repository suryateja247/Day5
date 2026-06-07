#!/usr/bin/env bash
set -euo pipefail

cluster_name="${1:?Usage: kube-login.sh <cluster-name> <aws-region> [role-arn]}"
aws_region="${2:?Usage: kube-login.sh <cluster-name> <aws-region> [role-arn]}"
role_arn="${3:-}"

if [ -n "$role_arn" ]; then
  aws eks update-kubeconfig --name "$cluster_name" --region "$aws_region" --role-arn "$role_arn"
else
  aws eks update-kubeconfig --name "$cluster_name" --region "$aws_region"
fi

kubectl get nodes
