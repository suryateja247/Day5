variable "project_name" {
  type        = string
  description = "Platform name."
}

variable "aws_region" {
  type        = string
  description = "AWS region used by the provider."
  default     = "ap-south-1"
}

variable "accounts" {
  description = "AWS Organization accounts to create. Run from the management account."
  type = map(object({
    name      = string
    email     = string
    role_name = optional(string, "OrganizationAccountAccessRole")
    parent_id = optional(string)
  }))
}
