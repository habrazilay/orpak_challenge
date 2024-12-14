# modules/security_groups/main.tf
#############################################
# Webserver and Load Balancer Security Group
#############################################
resource "aws_security_group" "web_and_alb" {
  name        = "web-and-alb"
  description = "Allow traffic for ALB and web server"
  vpc_id      = var.vpc_id

  # Allow inbound HTTP/HTTPS traffic from anywhere (for ALB and Web)
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "web-and-alb" })
}


