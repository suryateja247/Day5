locals {
  tags = {
    Platform = var.project_name
    Stack    = "shared-services"
  }
}

module "vpc" {
  source = "../modules/vpc"

  name     = "${var.project_name}-shared-services"
  vpc_cidr = var.vpc_cidr
  tags     = local.tags
}

module "eks" {
  source = "../modules/eks"

  cluster_name         = var.cluster_name
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  node_instance_types  = var.node_instance_types
  node_min_size        = var.node_min_size
  node_desired_size    = var.node_desired_size
  node_max_size        = var.node_max_size
  admin_principal_arns = var.admin_principal_arns
  tags                 = local.tags
}

module "eks_addons" {
  source = "../modules/eks-addons"

  cluster_name = module.eks.cluster_name
  aws_region   = var.aws_region

  depends_on = [module.eks]
}

module "jenkins" {
  source = "../modules/jenkins"

  admin_password         = var.jenkins_admin_password
  agent_image_repository = var.jenkins_agent_image_repository
  agent_image_tag        = var.jenkins_agent_image_tag

  depends_on = [module.eks_addons]
}

module "artifact_repository" {
  source = "../modules/artifact-repository"

  repository_type = var.artifact_repository_type
  admin_password  = var.artifact_admin_password

  depends_on = [module.eks_addons]
}

module "awx" {
  source = "../modules/awx"

  depends_on = [module.eks_addons]
}

module "observability" {
  source = "../modules/observability"

  depends_on = [module.eks_addons]
}
