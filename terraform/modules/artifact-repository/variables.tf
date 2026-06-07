variable "repository_type" {
  type        = string
  description = "Artifact repository type: jfrog or nexus."
  default     = "jfrog"

  validation {
    condition     = contains(["jfrog", "nexus"], var.repository_type)
    error_message = "repository_type must be jfrog or nexus."
  }
}

variable "namespace" {
  type        = string
  default     = "artifact-repository"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Initial artifact repository admin password."
}

variable "service_type" {
  type        = string
  default     = "LoadBalancer"
}

variable "storage_size" {
  type        = string
  default     = "200Gi"
}

variable "chart_version" {
  type        = string
  default     = null
  description = "Optional Helm chart version override."
}
