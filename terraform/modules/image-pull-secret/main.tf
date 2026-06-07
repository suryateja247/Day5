locals {
  docker_config = {
    auths = {
      (var.registry_url) = {
        username = var.registry_username
        password = var.registry_password
        auth     = base64encode("${var.registry_username}:${var.registry_password}")
      }
    }
  }
}

resource "kubernetes_secret" "this" {
  metadata {
    name      = var.secret_name
    namespace = var.namespace
  }

  data = {
    ".dockerconfigjson" = jsonencode(local.docker_config)
  }

  type = "kubernetes.io/dockerconfigjson"
}
