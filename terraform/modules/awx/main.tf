resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "awx_operator" {
  name       = "awx-operator"
  namespace  = kubernetes_namespace.this.metadata[0].name
  repository = "https://ansible-community.github.io/awx-operator-helm"
  chart      = "awx-operator"
  version    = var.chart_version
  timeout    = 600
}
