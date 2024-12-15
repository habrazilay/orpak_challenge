# modules/networks/variables.tf
variable "alb_sg_id" {
  description = "List of security group IDs for the ALB"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}
