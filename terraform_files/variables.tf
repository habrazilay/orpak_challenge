variable "cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"  # Replace with your preferred region
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "common_tags" {
  description = "Common tags for resources"
  default     = {
    Project     = "OrpakProject"
    Environment = "simulation"
  }
}

variable "trusted_ip" {
  description = "Trusted IP for SSH access"
  default     = "192.168.1.137/32" # Replace with your actual IP or placeholder
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "node_group_desired" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
  default     = 2
}

variable "node_group_max" {
  description = "Maximum number of nodes in the EKS node group"
  type        = number
  default     = 4
}

variable "node_group_min" {
  description = "Minimum number of nodes in the EKS node group"
  type        = number
  default     = 1
}

variable "node_group_instance_types" {
  description = "Instance types for EKS nodes"
  type        = list(string)
  default     = ["t2.micro"] # For simulation, regular reccomentdation t3.medium
}

variable "additional_iam_role_arn" {
  description = "IAM role ARN to attach to the node group"
  type        = string
}


