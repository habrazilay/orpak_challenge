# modules/networks/outputs.tf
output "public_subnet" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = data.aws_vpc.default.id
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = data.aws_vpc.default.cidr_block
}


