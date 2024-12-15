# modules/networks/outputs.tf
output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_subnets" {
  description = "IDs of all public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "IDs of all private subnets"
  value       = aws_subnet.private[*].id
}


