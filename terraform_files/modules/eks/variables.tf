# modules/eks/variables.tf
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "private_subnets" {
  description = "List of private subnet IDs for EKS"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "node_group_desired" {
  description = "Desired capacity for the node group"
  type        = number
  default     = 2
}

variable "node_group_max" {
  description = "Maximum capacity for the node group"
  type        = number
  default     = 4
}

variable "node_group_min" {
  description = "Minimum capacity for the node group"
  type        = number
  default     = 1
}

variable "node_group_instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}

variable "additional_iam_role_arn" {
  description = "IAM role ARN to attach to the node group"
  type        = string
}

variable "alb_sg_ids" {
  description = "List of ALB security group IDs"
  type        = list(string)
}

