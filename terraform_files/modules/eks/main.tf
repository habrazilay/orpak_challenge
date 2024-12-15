# modules/eks/main.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = var.vpc_id
  # cluster_role_arn   = aws_iam_role.eks_cluster_role.arn # Pass the IAM Role ARN for the cluster

  eks_managed_node_groups = {
    default = {
      desired_capacity = var.node_group_desired
      max_size         = var.node_group_max
      min_size         = var.node_group_min
      instance_types   = var.node_group_instance_types
      iam_role_arn     = var.additional_iam_role_arn

      # Specify subnets for this node group
      subnet_ids = var.private_subnets
    }
  }
  tags = var.common_tags
}
