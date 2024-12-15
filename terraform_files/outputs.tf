# terraform_files/outputs.tf
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networks.vpc_id
}

output "public_subnet" {
  description = "The ID of the public subnet"
  value       = module.networks.public_subnet
}

output "private_subnet" {
  description = "The ID of the private subnet"
  value       = module.networks.private_subnet
}

# Uncomment and update this output if needed later for EKS node group roles
# output "node_group_iam_role" {
#   description = "IAM Role ARN for the EKS managed node group"
#   value       = module.eks.eks_managed_node_groups["workers"].iam_role_arn
# }

