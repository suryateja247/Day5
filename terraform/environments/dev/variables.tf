variable "project_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "cluster_name" {
  type    = string
  default = "dev-eks"
}

variable "admin_principal_arns" {
  type    = list(string)
  default = []
}

variable "trusted_jenkins_principal_arns" {
  type        = list(string)
  description = "Shared-services Jenkins role/user ARNs allowed to assume this environment deploy role."
  default     = []
}

variable "default_app_namespace" {
  type    = string
  default = "sample-app"
}

variable "create_image_pull_secret" {
  type    = bool
  default = false
}

variable "registry_url" {
  type    = string
  default = "artifactory.example.com"
}

variable "registry_username" {
  type    = string
  default = "admin"
}

variable "registry_password" {
  type      = string
  sensitive = true
  default   = null
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 4
}
