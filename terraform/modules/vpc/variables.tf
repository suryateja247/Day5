variable "name" {
  type        = string
  description = "VPC name prefix."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
}

variable "az_count" {
  type        = number
  description = "Number of AZs to use."
  default     = 3
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create a single NAT gateway for private subnet egress."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Additional resource tags."
  default     = {}
}
