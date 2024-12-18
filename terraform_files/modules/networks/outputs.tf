# modules/networks/outputs.tf
# output "public_subnets" {
#   description = "List of public subnet IDs"
#   value       = [aws_subnet.public.id] # Wrap in a list to avoid coalescelist
# }

# output "private_subnets" {
#   description = "List of private subnet IDs"
#   value       = [aws_subnet.private.id]
# }

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}


output "vpc_id" {
  description = "ID of the VPC"
  value       = data.aws_vpc.main.id
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = data.aws_vpc.main.cidr_block
}


