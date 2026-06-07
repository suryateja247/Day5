variable "project_name" {
  description = "Short company or platform name."
  type        = string
}

variable "aws_region" {
  description = "AWS region for Terraform state resources."
  type        = string
  default     = "ap-south-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking."
  type        = string
}

variable "terraform_admin_arns" {
  description = "IAM principal ARNs allowed to administer Terraform state resources."
  type        = list(string)
  default     = []
}
