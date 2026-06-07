variable "namespace" {
  type    = string
  default = "awx"
}

variable "chart_version" {
  type        = string
  default     = null
  description = "Optional AWX operator Helm chart version."
}
