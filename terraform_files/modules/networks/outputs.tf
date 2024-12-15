# modules/networks/outputs.tf
# output "public_subnets" {
#   description = "IDs of all public subnets"
#   value       = [for subnet in aws_subnet.public : subnet.id] 
# }

output "public_subnets" {
  description = "IDs of all public subnets"
  value       = aws_subnet.public[*].id
}


# output "private_subnets" {
#   description = "IDs of all private subnets"
#   value       = [for subnet in aws_subnet.private : subnet.id] 
# }

output "private_subnets" {
  description = "IDs of all private subnets"
  value       = aws_subnet.private[*].id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = data.aws_vpc.default.id
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = data.aws_vpc.default.cidr_block 
}


