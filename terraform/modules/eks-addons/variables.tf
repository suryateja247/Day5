variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}

variable "aws_region" {
  type        = string
  description = "AWS region."
}

variable "install_ingress_nginx" {
  type        = bool
  default     = true
}

variable "install_cert_manager" {
  type        = bool
  default     = true
}

variable "install_external_secrets" {
  type        = bool
  default     = true
}

variable "install_aws_load_balancer_controller" {
  type        = bool
  default     = true
}
