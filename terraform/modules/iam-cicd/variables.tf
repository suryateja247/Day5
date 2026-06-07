variable "role_name" {
  type        = string
  description = "IAM role name to create for Jenkins or Terraform automation."
}

variable "trusted_principal_arns" {
  type        = list(string)
  description = "AWS principal ARNs allowed to assume the role."
}

variable "policy_json" {
  type        = string
  description = "IAM policy JSON attached to the role."
}

variable "tags" {
  type    = map(string)
  default = {}
}
