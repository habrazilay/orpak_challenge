output "alb_sg_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "private_sg_id" {
  description = "Security Group ID for private resources"
  value       = aws_security_group.private_sg.id
}
