# main.tf
# Provider configuration
provider "aws" {
  region = var.aws_region
}

# Instantiate the security groups module
module "security_groups" {
  source      = "./modules/security_groups"
  vpc_id      = module.networks.vpc_id
  common_tags = var.common_tags

  # Provide the ALB SG ID
  # alb_sg_id = aws_security_group.alb.id  # Replace with the actual source of the ALB SG ID
  alb_sg_id = "sg-0123456789abcdef0"  # Simulated placeholders
}

# Instantiate the IAM roles
module "iam" {
  source = "./modules/iam"
  common_tags = var.common_tags
}

# Instantiate the EKS module
module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = module.networks.vpc_id
  private_subnets    = module.networks.private_subnets
  node_group_desired = var.node_group_desired
  node_group_max     = var.node_group_max
  node_group_min     = var.node_group_min
  node_group_instance_types = var.node_group_instance_types
  common_tags        = var.common_tags

  # Pass the ALB Security Group ID(s) from the security_groups module
  alb_sg_ids = [module.security_groups.web_and_alb_sg_id]

  # Provide the required IAM role ARN
  additional_iam_role_arn = var.additional_iam_role_arn
}

# Instantiate the networks module
module "networks" {
  source             = "./modules/networks"
  cidr_block         = var.cidr_block
  availability_zones = var.availability_zones
  common_tags        = var.common_tags
  # web_and_alb_sg_id = module.security_groups.web_and_alb_sg_id
  web_and_alb_sg_id  = "sg-0123456789abcdef0" # Simulated placeholders
}





