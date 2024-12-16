# modules/eks/outputs.tf
output "cluster_id" {
  description = "The EKS cluster ID"
  value       = module.eks.cluster_id
}

# output "node_group_arns" {
#   description = "The ARNs of the EKS node groups"
#   value       = module.eks.eks_managed_node_groups[*].arn
# }

# # Simulated placeholder value
# output "kubeconfig" {
#   description = "The kubeconfig file for accessing the EKS cluster"
#   value       = module.eks.kubeconfig
# }

output "kubeconfig" {
  description = "The kubeconfig details for the EKS cluster"
  value = {
    api_server_endpoint    = module.eks.cluster_endpoint
    cluster_ca_certificate = module.eks.cluster_certificate_authority_data
    cluster_name           = module.eks.cluster_name
  }
}

