variable "namespace" {
  type        = string
  default     = "jenkins"
}

variable "admin_username" {
  type        = string
  default     = "admin"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Initial Jenkins admin password."
}

variable "service_type" {
  type        = string
  default     = "LoadBalancer"
}

variable "storage_class" {
  type        = string
  default     = "gp2"
}

variable "storage_size" {
  type        = string
  default     = "50Gi"
}

variable "install_plugins" {
  type = list(string)
  default = [
    "kubernetes",
    "workflow-aggregator",
    "git",
    "configuration-as-code",
    "credentials-binding",
    "pipeline-stage-view",
    "ansicolor",
    "blueocean",
    "docker-workflow",
    "matrix-auth"
  ]
}

variable "agent_image_repository" {
  type        = string
  description = "Jenkins inbound agent image repository with enterprise DevOps tools installed."
  default     = "jenkins/inbound-agent"
}

variable "agent_image_tag" {
  type        = string
  description = "Jenkins inbound agent image tag."
  default     = "latest-jdk17"
}
