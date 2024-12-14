variable "vpc_id" {
  description = "VPC ID for the security groups"
  type        = string
}

variable "trusted_ip" {
  description = "Trusted IP for SSH access"
  default     = "192.168.1.1/32" # Replace with your actual IP or placeholder
}

variable "alb_sg_id" {
  description = "Security Group ID of the ALB"
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}

