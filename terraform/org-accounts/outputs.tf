output "account_ids" {
  value = {
    for key, account in aws_organizations_account.this : key => account.id
  }
}

output "account_arns" {
  value = {
    for key, account in aws_organizations_account.this : key => account.arn
  }
}
