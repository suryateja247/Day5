variable "namespace" {
  type = string
}

variable "secret_name" {
  type    = string
  default = "artifact-registry-pull-secret"
}

variable "registry_url" {
  type = string
}

variable "registry_username" {
  type = string
}

variable "registry_password" {
  type      = string
  sensitive = true
}
