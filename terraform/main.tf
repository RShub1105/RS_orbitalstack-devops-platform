locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project
    Owner       = var.owner
  }
}

module "vpc" {
  source      = "./modules/vpc"
  environment = var.environment
  tags        = local.common_tags
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  environment     = var.environment
  tags            = local.common_tags
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
}

module "s3" {
  source      = "./modules/s3"
  environment = var.environment
  tags        = local.common_tags
}

module "iam" {
  source             = "./modules/iam"
  environment        = var.environment
  tags               = local.common_tags
  telemetry_oidc_arn = module.eks.oidc_provider_arn
  telemetry_oidc_url = module.eks.oidc_provider_url
}

module "timescaledb" {
  source             = "./modules/timescaledb"
  environment        = var.environment
  tags               = local.common_tags
  db_username        = var.db_username
  db_password        = var.db_password
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_node_sg_id     = module.eks.node_security_group_id
}

module "iot" {
  source      = "./modules/iot"
  environment = var.environment
  tags        = local.common_tags
}
