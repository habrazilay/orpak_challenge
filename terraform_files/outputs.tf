# terraform_files/outputs.tf
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networks.vpc_id
}

output "public_subnets" {
  description = "The ID of the public subnet"
  value       = module.networks.public_subnets
}

output "private_subnets" {
  description = "The ID of the private subnet"
  value       = module.networks.private_subnets
}

output "eks_node_group_role" {
  description = "IAM role ARN for the EKS node group"
  value       = module.iam.node_group_iam_role
}

output "kubeconfig" {
  description = "The kubeconfig file for accessing the EKS cluster"
  value       = module.eks.kubeconfig
}



# Uncomment and update this output if needed later for EKS node group roles
# output "node_group_iam_role" {
#   description = "IAM Role ARN for the EKS managed node group"
#   value       = module.eks.eks_managed_node_groups["workers"].iam_role_arn
# }

