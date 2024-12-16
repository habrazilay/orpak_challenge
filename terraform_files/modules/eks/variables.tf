# terraform_files/modules/eks/variables.tf
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of Kubernetes for the cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be created"
  type        = string
}

# FIX: Add a variable for control_plane_subnet_ids as it is required for coalescelist and default to an empty list if not provided
variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster"
  type        = list(string)
  default     = []
}


variable "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_group_desired" {
  description = "Desired number of nodes in the node group"
  type        = number
}

variable "node_group_max" {
  description = "Maximum number of nodes in the node group"
  type        = number
}

variable "node_group_min" {
  description = "Minimum number of nodes in the node group"
  type        = number
}

variable "node_group_instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
}

variable "alb_sg_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "additional_iam_role_arn" {
  description = "Additional IAM role ARN for the node group"
  type        = string
}

variable "common_tags" {
  description = "Common tags for the resources"
  type        = map(string)
}

variable "cluster_role_arn" {
  description = "IAM Role ARN for the EKS cluster control plane"
  type        = string
}
