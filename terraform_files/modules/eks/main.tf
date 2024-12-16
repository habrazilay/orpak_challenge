# modules/eks/main.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = var.vpc_id
  subnet_ids         = ["subnet-0246176e0662618df", "subnet-060edf84a2343c800"] # Private and public subnets for the cluster
  # iam_role_arn = module.iam.eks_cluster_role_arn

  eks_managed_node_groups = {
    default = {
      desired_capacity = var.node_group_desired
      max_size         = var.node_group_max
      min_size         = var.node_group_min
      instance_types   = var.node_group_instance_types
      # iam_role_arn     = var.additional_iam_role_arn

      # Subnets for node groups (e.g., private subnets)
      subnet_ids = ["subnet-0246176e0662618df"]
    }
  }

  tags = var.common_tags
}



# resource "aws_eks_cluster" "this" {
#   name     = var.cluster_name
#   role_arn = var.cluster_role_arn

#   vpc_config {
#     subnet_ids = var.subnet_ids
#   }

#   tags = var.common_tags
# }


