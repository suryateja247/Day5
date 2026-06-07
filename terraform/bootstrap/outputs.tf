output "state_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "lock_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}

output "kms_key_arn" {
  value = aws_kms_key.terraform_state.arn
}

output "terraform_state_admin_role_arn" {
  value = aws_iam_role.terraform_state_admin.arn
}

output "backend_hcl_example" {
  value = <<EOT
bucket         = "${aws_s3_bucket.terraform_state.id}"
key            = "REPLACE_WITH_STACK_NAME/terraform.tfstate"
region         = "${var.aws_region}"
dynamodb_table = "${aws_dynamodb_table.terraform_locks.name}"
encrypt        = true
EOT
}
