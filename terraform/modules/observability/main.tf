resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  name       = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.this.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  timeout    = 900
}

resource "helm_release" "fluent_bit" {
  count = var.install_fluent_bit ? 1 : 0

  name       = "aws-for-fluent-bit"
  namespace  = kubernetes_namespace.this.metadata[0].name
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-for-fluent-bit"
}
