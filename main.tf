# Appstract AWS Infrastructure
# Main configuration file

# Provider configuration is in providers.tf
# Backend configuration is in backend.tf

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = local.common_tags
}

# ECR Module - Create repositories for all 4 services
module "ecr" {
  source = "./modules/ecr"

  environment   = var.environment
  service_names = var.service_names
  tags          = local.common_tags
}

# IAM Module - Create roles and policies
module "iam" {
  source = "./modules/iam"

  environment = var.environment
  tags        = local.common_tags
}

# S3 Module - Create buckets for static files
module "s3" {
  source = "./modules/s3"

  environment  = var.environment
  bucket_names = var.bucket_names
  tags         = local.common_tags
}

# Secrets Manager Module
module "secrets_manager" {
  source = "./modules/secrets-manager"

  environment = var.environment
  tags        = local.common_tags
}

# DocumentDB Module
module "documentdb" {
  source = "./modules/documentdb"

  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnet_ids
  documentdb_name           = var.documentdb_name
  documentdb_version        = var.documentdb_version
  documentdb_instance_class = var.documentdb_instance_class
  documentdb_instance_count = var.documentdb_instance_count
  security_group_ids        = [module.vpc.default_security_group_id]
  tags                      = local.common_tags

  depends_on = [module.vpc]
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn   = var.certificate_arn
  tags              = local.common_tags

  depends_on = [module.vpc]
}

# ECS Module
# module "ecs" {
#   source = "./modules/ecs"

#   environment           = var.environment
#   vpc_id                = module.vpc.vpc_id
#   private_subnet_ids    = module.vpc.private_subnet_ids
#   alb_security_group_id = module.alb.security_group_id
#   target_group_arns     = module.alb.target_group_arns
#   execution_role_arn    = module.iam.ecs_execution_role_arn
#   task_role_arn         = module.iam.ecs_task_role_arn
#   container_insights    = var.container_insights
#   service_configs       = var.service_configs
#   tags                  = local.common_tags

#   depends_on = [module.vpc, module.alb, module.iam]
# }

# # Bastion Host Module (optional)
# module "bastion" {
#   source = "./modules/bastion"
#   count  = var.create_bastion ? 1 : 0

#   environment       = var.environment
#   vpc_id            = module.vpc.vpc_id
#   subnet_id         = module.vpc.public_subnet_ids[0]
#   ssh_key_name      = var.bastion_ssh_key_name
#   allowed_cidr      = var.bastion_allowed_cidr
#   tags              = local.common_tags

#   depends_on = [module.vpc]
# }
