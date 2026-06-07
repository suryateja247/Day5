variable "project_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.50.0.0/16"
}

variable "cluster_name" {
  type    = string
  default = "prod-eks"
}

variable "admin_principal_arns" {
  type    = list(string)
  default = []
}

variable "trusted_jenkins_principal_arns" {
  type    = list(string)
  default = []
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
  default = ["m6i.large"]
}

variable "node_min_size" {
  type    = number
  default = 3
}

variable "node_desired_size" {
  type    = number
  default = 4
}

variable "node_max_size" {
  type    = number
  default = 10
}
