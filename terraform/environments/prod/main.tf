locals {
  tags = {
    Platform    = var.project_name
    Environment = var.environment
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name     = "${var.project_name}-${var.environment}"
  vpc_cidr = var.vpc_cidr
  tags     = local.tags
}

module "eks" {
  source = "../../modules/eks"

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
  source = "../../modules/eks-addons"

  cluster_name = module.eks.cluster_name
  aws_region   = var.aws_region

  depends_on = [module.eks]
}

resource "kubernetes_namespace" "default_app" {
  metadata {
    name = var.default_app_namespace
  }

  depends_on = [module.eks_addons]
}

module "image_pull_secret" {
  count  = var.create_image_pull_secret ? 1 : 0
  source = "../../modules/image-pull-secret"

  namespace         = kubernetes_namespace.default_app.metadata[0].name
  registry_url      = var.registry_url
  registry_username = var.registry_username
  registry_password = var.registry_password
}

data "aws_iam_policy_document" "jenkins_deploy" {
  statement {
    sid = "AllowJenkinsEnvironmentDeploy"
    actions = [
      "eks:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "cloudwatch:*",
      "logs:*",
      "autoscaling:*",
      "ssm:*",
      "secretsmanager:GetSecretValue",
      "iam:GetRole",
      "iam:PassRole"
    ]
    resources = ["*"]
  }
}

module "jenkins_deploy_role" {
  count  = length(var.trusted_jenkins_principal_arns) > 0 ? 1 : 0
  source = "../../modules/iam-cicd"

  role_name              = "${var.project_name}-${var.environment}-jenkins-deploy"
  trusted_principal_arns = var.trusted_jenkins_principal_arns
  policy_json            = data.aws_iam_policy_document.jenkins_deploy.json
  tags                   = local.tags
}
