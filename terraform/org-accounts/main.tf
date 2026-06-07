resource "aws_organizations_account" "this" {
  for_each = var.accounts

  name      = each.value.name
  email     = each.value.email
  role_name = each.value.role_name
  parent_id = try(each.value.parent_id, null)

  close_on_deletion = false

  tags = {
    AccountKey = each.key
  }
}
