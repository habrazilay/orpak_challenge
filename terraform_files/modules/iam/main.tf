# IAM Role for the EKS Cluster (Control Plane)
# resource "aws_iam_role" "eks_cluster_role" {
#   name               = "MyEKSClusterRole"
#   assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json

#   tags = merge(var.common_tags, { "Name" = "EKSClusterRole" })
# }

# data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["eks.amazonaws.com"]
#     }
#   }
# }

# Attach required policies for EKS Cluster Role
# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   role       = aws_iam_role.eks_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

# resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller_policy" {
#   role       = aws_iam_role.eks_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
# }

# Output for the EKS Cluster Role ARN
# output "eks_cluster_role_arn" {
#   description = "The ARN of the IAM role for the EKS cluster control plane"
#   value       = aws_iam_role.eks_cluster_role.arn
# }

# Node Group Role (Retained if needed)
# resource "aws_iam_role" "eks_node_group" {
#   name               = "MyEKSNodeGroupRole"
#   assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

#   tags = merge(var.common_tags, { "Name" = "EKSNodeGroupRole" })
# }

# data "aws_iam_policy_document" "assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

# Attach required policies for EKS Node Group Role
# resource "aws_iam_role_policy_attachment" "eks_worker_node" {
#   role       = aws_iam_role.eks_node_group.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

# resource "aws_iam_role_policy_attachment" "eks_cni" {
#   role       = aws_iam_role.eks_node_group.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

# resource "aws_iam_role_policy_attachment" "ecr_read_only" {
#   role       = aws_iam_role.eks_node_group.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }

# Output for the EKS Node Group Role ARN
# output "eks_node_group_role_arn" {
#   description = "The ARN of the IAM role for the EKS node group"
#   value       = aws_iam_role.eks_node_group.arn
# }
