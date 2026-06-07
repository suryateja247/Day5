output "installed_addons" {
  value = compact([
    var.install_ingress_nginx ? "ingress-nginx" : "",
    var.install_cert_manager ? "cert-manager" : "",
    var.install_external_secrets ? "external-secrets" : "",
    var.install_aws_load_balancer_controller ? "aws-load-balancer-controller" : ""
  ])
}
