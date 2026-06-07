# Terraform Guide

Run order:

1. `bootstrap`
2. `org-accounts` if you want Terraform to create AWS Organization accounts
3. `shared-services`
4. `environments/dev`
5. `environments/qa`
6. `environments/stage`
7. `environments/prod`

Each stack should use its own backend key, for example:

```hcl
bucket         = "my-company-terraform-state"
key            = "shared-services/terraform.tfstate"
region         = "ap-south-1"
dynamodb_table = "my-company-terraform-locks"
encrypt        = true
```

Do not share one Terraform state file across environments.
