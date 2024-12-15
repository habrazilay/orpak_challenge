# terraform_files/modules/security_groups/variables.tf
variable "vpc_id" {
  description = "VPC ID for the security groups"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC, used to allow internal traffic"
  type        = string
}

variable "trusted_ip" {
  description = "Trusted IP for SSH access"
  default     = "176.231.81.11/32" # Replace with your actual IP or placeholder
}

variable "alb_sg_id" {
  description = "Security Group ID of the ALB"
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}

