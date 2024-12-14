# modules/security_groups/outputs.tf
output "web_and_alb_sg_id" {
  description = "Security Group ID for Webserver and ALB"
  value       = aws_security_group.web_and_alb.id
}


