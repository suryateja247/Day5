locals {
  chart = {
    jfrog = {
      repository = "https://charts.jfrog.io"
      chart      = "artifactory"
    }
    nexus = {
      repository = "https://sonatype.github.io/helm3-charts"
      chart      = "nexus-repository-manager"
    }
  }

  selected = local.chart[var.repository_type]

  jfrog_values = {
    artifactory = {
      service = {
        type = var.service_type
      }
      persistence = {
        size = var.storage_size
      }
      artifactory = {
        admin = {
          password = var.admin_password
        }
      }
    }
    postgresql = {
      enabled = true
    }
  }

  nexus_values = {
    service = {
      type = var.service_type
    }
    persistence = {
      enabled = true
      storageSize = var.storage_size
    }
    nexus = {
      docker = {
        enabled = true
      }
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "admin" {
  metadata {
    name      = "artifact-repository-admin"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  data = {
    username = "admin"
    password = var.admin_password
  }

  type = "Opaque"
}

resource "helm_release" "this" {
  name       = var.repository_type
  namespace  = kubernetes_namespace.this.metadata[0].name
  repository = local.selected.repository
  chart      = local.selected.chart
  version    = var.chart_version
  timeout    = 900

  values = [
    yamlencode(var.repository_type == "jfrog" ? local.jfrog_values : local.nexus_values)
  ]
}
