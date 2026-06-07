resource "kubernetes_namespace" "ingress_nginx" {
  count = var.install_ingress_nginx ? 1 : 0

  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  count = var.install_ingress_nginx ? 1 : 0

  name       = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress_nginx[0].metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  values = [
    yamlencode({
      controller = {
        service = {
          type = "LoadBalancer"
        }
      }
    })
  ]
}

resource "kubernetes_namespace" "cert_manager" {
  count = var.install_cert_manager ? 1 : 0

  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  count = var.install_cert_manager ? 1 : 0

  name       = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager[0].metadata[0].name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubernetes_namespace" "external_secrets" {
  count = var.install_external_secrets ? 1 : 0

  metadata {
    name = "external-secrets"
  }
}

resource "helm_release" "external_secrets" {
  count = var.install_external_secrets ? 1 : 0

  name       = "external-secrets"
  namespace  = kubernetes_namespace.external_secrets[0].metadata[0].name
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
}

resource "kubernetes_namespace" "aws_load_balancer_controller" {
  count = var.install_aws_load_balancer_controller ? 1 : 0

  metadata {
    name = "aws-load-balancer-controller"
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  count = var.install_aws_load_balancer_controller ? 1 : 0

  name       = "aws-load-balancer-controller"
  namespace  = kubernetes_namespace.aws_load_balancer_controller[0].metadata[0].name
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "region"
    value = var.aws_region
  }
}
