output "cluster_name" {
  value = module.eks.cluster_name
}

output "kubeconfig_command" {
  value = module.eks.kubeconfig_command
}

output "jenkins_namespace" {
  value = module.jenkins.namespace
}

output "artifact_repository_type" {
  value = module.artifact_repository.repository_type
}

output "artifact_repository_namespace" {
  value = module.artifact_repository.namespace
}

output "awx_namespace" {
  value = module.awx.namespace
}

output "monitoring_namespace" {
  value = module.observability.namespace
}
