variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}

variable "kubernetes_version" {
  type        = string
  description = "EKS Kubernetes version."
  default     = "1.30"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the EKS cluster and nodes."
}

variable "public_access_cidrs" {
  type        = list(string)
  description = "CIDR ranges allowed to access the public EKS API endpoint."
  default     = ["0.0.0.0/0"]
}

variable "node_instance_types" {
  type        = list(string)
  description = "Managed node group instance types."
  default     = ["t3.large"]
}

variable "node_desired_size" {
  type        = number
  default     = 2
}

variable "node_min_size" {
  type        = number
  default     = 1
}

variable "node_max_size" {
  type        = number
  default     = 5
}

variable "admin_principal_arns" {
  type        = list(string)
  description = "IAM principal ARNs to grant cluster admin access."
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = {}
}
