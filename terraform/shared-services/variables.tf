variable "project_name" {
  type        = string
  description = "Platform name."
}

variable "aws_region" {
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.10.0.0/16"
}

variable "cluster_name" {
  type        = string
  default     = "shared-services-eks"
}

variable "admin_principal_arns" {
  type        = list(string)
  description = "IAM principals with EKS admin access."
  default     = []
}

variable "jenkins_admin_password" {
  type        = string
  sensitive   = true
  description = "Initial Jenkins admin password."
}

variable "artifact_repository_type" {
  type        = string
  default     = "jfrog"
  description = "jfrog or nexus."
}

variable "artifact_admin_password" {
  type        = string
  sensitive   = true
  description = "Initial artifact repository admin password."
}

variable "jenkins_agent_image_repository" {
  type        = string
  default     = "jenkins/inbound-agent"
  description = "Jenkins agent image repository. Use the custom tools image after building it."
}

variable "jenkins_agent_image_tag" {
  type        = string
  default     = "latest-jdk17"
  description = "Jenkins agent image tag."
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.large"]
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_desired_size" {
  type    = number
  default = 3
}

variable "node_max_size" {
  type    = number
  default = 8
}
