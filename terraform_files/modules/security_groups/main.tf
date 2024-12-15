# terraform_files/modules/security_groups/main.tf
#############################################
# Webserver and Load Balancer Security Group
#############################################
resource "aws_security_group" "web_and_alb" {
  name        = "web-and-alb"
  description = "Allow traffic for ALB and web server"
  vpc_id      = var.vpc_id

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

  ingress {
    description = "Allow SSH from trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.trusted_ip]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "web-and-alb" })
}

#############################################
# Private Security Group (e.g., EKS, RDS, etc.)
#############################################
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow internal traffic for private instances"
  vpc_id      = var.vpc_id


  ingress {
    description = "Allow all internal traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    description = "Allow outbound internet access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "private-sg" })
}

#############################################
# Rule for Traffic from Web and ALB Security Group
#############################################
resource "aws_security_group_rule" "allow_alb_to_private" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_and_alb.id
  security_group_id        = aws_security_group.private_sg.id
  description              = "Allow traffic from ALB to private SG"
}
