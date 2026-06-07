resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "admin" {
  metadata {
    name      = "jenkins-admin"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  data = {
    username = var.admin_username
    password = var.admin_password
  }

  type = "Opaque"
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = kubernetes_namespace.this.metadata[0].name
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"

  values = [
    yamlencode({
      controller = {
        serviceType = var.service_type
        admin = {
          existingSecret = kubernetes_secret.admin.metadata[0].name
          userKey        = "username"
          passwordKey    = "password"
        }
        installPlugins = var.install_plugins
        JCasC = {
          defaultConfig = true
          configScripts = {
            welcome = <<-EOT
              jenkins:
                systemMessage: "Enterprise DevOps Jenkins - CI/CD logs are centralized here."
            EOT
          }
        }
      }
      persistence = {
        enabled      = true
        storageClass = var.storage_class
        size         = var.storage_size
      }
      agent = {
        enabled = true
        image = {
          repository = var.agent_image_repository
          tag        = var.agent_image_tag
        }
      }
    })
  ]

  depends_on = [kubernetes_secret.admin]
}
