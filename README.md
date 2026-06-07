# AWS Enterprise DevOps Platform

This repository is a reusable starter platform for enterprise AWS DevOps:

- Multi-account AWS foundation.
- Terraform automation for AWS infrastructure and platform tools.
- Jenkins as the CI and CD control plane.
- Docker image build, scan, and push to JFrog Artifactory or Sonatype Nexus.
- Kubernetes deployments through Helm.
- Ansible deployments for VM, middleware, or non-container workloads.
- Jenkins console logs for CI, Terraform, Kubernetes, and Ansible stages.

## Repository Layout

```text
terraform/
  bootstrap/              # S3 backend, DynamoDB locking, KMS, Terraform role
  org-accounts/           # Optional AWS Organizations account creation
  shared-services/        # Jenkins, artifact repository, AWX, monitoring on EKS
  environments/           # dev, qa, stage, prod workload EKS stacks
  modules/                # Reusable Terraform modules
jenkins/
  pipelines/              # Jenkinsfiles for platform and app delivery
  shared-library/vars/    # Reusable Jenkins pipeline functions
kubernetes/
  helm/app-chart/         # Reusable Helm chart for app deployment
ansible/
  inventories/            # Dynamic/static inventory examples
  playbooks/              # Deployment playbooks
  roles/                  # Ansible roles
scripts/                  # Local/Jenkins helper scripts
examples/sample-app/      # Small Dockerized sample app
```

## Prerequisites

Install or provide these tools on the operator workstation and Jenkins agents:

- AWS CLI v2
- Terraform 1.7 or newer
- Docker or a compatible builder
- kubectl
- Helm
- Ansible
- Trivy or another image scanner
- Git

AWS prerequisites:

- AWS Organizations enabled.
- Control Tower recommended for real enterprise landing zones.
- AWS SSO/IAM Identity Center recommended for human access.
- Separate AWS accounts for shared services, dev, qa, stage, and prod.
- IAM roles that Jenkins can assume in each target account.

## High-Level Flow

```text
Developer commits code
  -> Jenkins CI
  -> test/build Docker image
  -> scan image
  -> push image to JFrog or Nexus
  -> Jenkins CD
  -> optional Terraform plan/apply
  -> deploy to Kubernetes with Helm or to servers with Ansible
  -> smoke test
  -> logs visible in Jenkins
```

## Deployment Order

1. Bootstrap Terraform state:

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

2. Optional: create or register AWS accounts:

```bash
cd terraform/org-accounts
terraform init
terraform apply
```

3. Deploy shared services:

```bash
cd terraform/shared-services
terraform init
terraform apply
```

This creates the shared-services VPC/EKS cluster and installs Jenkins, the artifact repository, AWX, and monitoring through Helm.

4. Build and push the Jenkins agent tools image:

```bash
export REGISTRY_URL=artifactory.example.com/docker-local
export REGISTRY_USERNAME=admin
export REGISTRY_PASSWORD=replace-me
./scripts/build-jenkins-agent-image.sh
```

Then set these values in `terraform/shared-services/terraform.tfvars` and re-apply the shared-services stack:

```hcl
jenkins_agent_image_repository = "artifactory.example.com/docker-local/jenkins-agent-tools"
jenkins_agent_image_tag        = "latest"
```

5. Deploy workload environments:

```bash
cd terraform/environments/dev
terraform init
terraform apply

cd ../qa
terraform init
terraform apply

cd ../stage
terraform init
terraform apply

cd ../prod
terraform init
terraform apply
```

6. Configure Jenkins:

- Add this repo as a Jenkins shared library.
- Create a multibranch app pipeline using `jenkins/pipelines/Jenkinsfile.app`.
- Create a platform pipeline using `jenkins/pipelines/Jenkinsfile.platform`.
- Store registry credentials in Jenkins as `artifact-registry-creds`.
- Store AWS role ARNs as parameters or folder-level credentials.

## Artifact Repository Choice

The Terraform module supports either:

- `jfrog`
- `nexus`

Set this in `terraform/shared-services/terraform.tfvars`:

```hcl
artifact_repository_type = "jfrog"
```

or:

```hcl
artifact_repository_type = "nexus"
```

## Enterprise Rule

Build each Docker image once, push it to the artifact repository, then promote the same immutable tag or digest through:

```text
dev -> qa -> stage -> prod
```

Do not rebuild the image separately for each environment.

## Notes

This is a production-grade scaffold, not a magic one-click enterprise deployment. You must still provide account IDs, DNS zones, TLS certificates, credential IDs, SSO/IAM roles, storage choices, and security approvals for your organization.
