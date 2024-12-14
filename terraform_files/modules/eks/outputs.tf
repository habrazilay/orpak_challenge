# modules/eks/outputs.tf
output "cluster_id" {
  description = "The EKS cluster ID"
  value       = module.eks.cluster_id
}

# output "node_group_arns" {
#   description = "The ARNs of the EKS node groups"
# #   value       = module.eks.eks_managed_node_groups[*].arn
# value       = ["arn:aws:eks:region:account-id:nodegroup/cluster-name/node-group-name"]  # Simulated placeholder
# }

# Simulated placeholder value
# output "kubeconfig" {
#   description = "Kubeconfig file to connect to the cluster"
#   value       = module.eks.kubeconfig
# }
