output "vpc_id" {
  value = module.networks.vpc_id
}

output "private_subnets" {
  value = module.networks.private_subnets
}

output "public_subnets" {
  value = module.networks.public_subnets
}

# output "node_group_iam_role" {
#   value = module.eks.eks_managed_node_groups["workers"].iam_role_arn
# }
