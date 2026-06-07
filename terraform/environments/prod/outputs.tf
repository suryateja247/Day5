output "cluster_name" {
  value = module.eks.cluster_name
}

output "kubeconfig_command" {
  value = module.eks.kubeconfig_command
}

output "default_app_namespace" {
  value = kubernetes_namespace.default_app.metadata[0].name
}

output "jenkins_deploy_role_arn" {
  value = try(module.jenkins_deploy_role[0].role_arn, null)
}
