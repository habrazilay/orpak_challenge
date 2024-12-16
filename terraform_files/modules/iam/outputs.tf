# modules/iam/outputs.tf
# output "node_group_iam_role" {
#   description = "IAM Role ARN for the EKS Node Group"
#   value       = module.iam.node_group_iam_role
# }

output "node_group_iam_role" {
  description = "IAM Role ARN for the EKS Node Group"
  value       = aws_iam_role.eks_node_group.arn
}

output "cluster_role_arn" {
  description = "IAM Role ARN for the EKS Cluster Role"
  value       = aws_iam_role.eks_cluster_role.arn
}
