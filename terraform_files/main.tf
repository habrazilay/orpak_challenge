# terraform_files/modules/networks/main.tf
# Provider configuration
provider "aws" {
  region = var.aws_region
}

# Instantiate the security groups module
module "security_groups" {
  source      = "./modules/security_groups"
  vpc_id      = module.networks.vpc_id
  cidr_block  = module.networks.cidr_block
  common_tags = var.common_tags
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
  subnet_ids         = ["subnet-0246176e0662618df"] #module.networks.private_subnets
  private_subnets    = ["subnet-0246176e0662618df"] # module.networks.private_subnets
  public_subnets     = ["subnet-060edf84a2343c800"] # module.networks.public_subnets
  node_group_desired = var.node_group_desired
  node_group_max     = var.node_group_max
  node_group_min     = var.node_group_min
  node_group_instance_types = var.node_group_instance_types
  alb_sg_ids         = [module.security_groups.alb_sg_id]
  cluster_role_arn = module.iam.cluster_role_arn
  additional_iam_role_arn  = module.iam.eks_node_group_role_arn # Add this line
  common_tags        = var.common_tags
}


# Instantiate the networks module
module "networks" {
  source             = "./modules/networks"
  cidr_block         = var.cidr_block
  availability_zones = var.availability_zones
  common_tags        = var.common_tags
  alb_sg_id          = module.security_groups.alb_sg_id # Pass the renamed variable
}

# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bucket"
#     key            = "terraform/state/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state-lock"
#   }
# }






