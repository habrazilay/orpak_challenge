# modules/networks/main.tf
#############################################

# Virtual Private Cloud:

#############################################
# resource "aws_vpc" "main" {
#   cidr_block = var.cidr_block
#   enable_dns_support = true
#   enable_dns_hostnames = true

#   tags = merge(var.common_tags, { "Name" = "main-vpc" })
# }

# Uses the default VPC for my simmulation
data "aws_vpc" "default" {
  default = true
}


#############################################

# Public subnets:

#############################################
resource "aws_subnet" "public" {
  for_each           = toset(var.availability_zones) # Loop over availability zones
  vpc_id             = aws_vpc.main.id
  cidr_block         = cidrsubnet(var.cidr_block, 8, index(var.availability_zones, each.key))
  availability_zone  = each.key
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, { Name = "public-subnet-${each.key}", Type = "Public" })
}

#############################################

# Private subnets:

#############################################
resource "aws_subnet" "private" {
  for_each           = toset(var.availability_zones) # Loop over availability zones
  vpc_id             = aws_vpc.main.id
  cidr_block         = cidrsubnet(var.cidr_block, 8, index(var.availability_zones, each.key) + length(var.availability_zones))
  availability_zone  = each.key
  map_public_ip_on_launch = false

  tags = merge(var.common_tags, { Name = "private-subnet-${each.key}", Type = "Private" })
}

#############################################

# Internet Gateway:

#############################################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, { Name = "Main" })
}

#############################################

# NAT's:

#############################################
resource "aws_nat_gateway" "nat" {
  for_each       = toset(var.availability_zones)
  allocation_id  = aws_eip.nat[each.key].id
  subnet_id      = aws_subnet.public[each.key].id

  tags = {
    Name = "nat-gateway-${each.key}"
  }

  depends_on = [aws_internet_gateway.main]
}

#############################################

# Elastic IP for NAT Gateways:

#############################################

resource "aws_eip" "nat" {
  for_each = toset(var.availability_zones)

  tags = {
    Name = "eip-for-nat-${each.key}"
  }
}


#############################################

# Public Route:

#############################################
resource "aws_route_table" "public" {
  for_each = toset(var.availability_zones)
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, { Name = "public-rt-${each.key}", Type = "Public" })
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
  for_each       = toset(var.availability_zones)
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

#############################################

# Private Route:

#############################################
resource "aws_route_table" "private" {
  for_each = toset(var.availability_zones)
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[each.key].id
  }

  tags = merge(var.common_tags, { Name = "private-rt-${each.key}", Type = "Private" })
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
  for_each       = toset(var.availability_zones)
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

####################################################
# Application Load balancer
####################################################
resource "aws_alb" "alb1" {
  name               = "alb1"
  internal           = false
  # security_groups    = [aws_security_group.alb.id]
  security_groups = ["sg-0123456789abcdef0"]  # Simulated placeholders
  # subnets            = aws_subnet.public[*].id
  subnets = ["subnet-0123456789abcdef0", "subnet-abcdef0123456789"]  # Simulated placeholders


  enable_deletion_protection     = false
  enable_cross_zone_load_balancing = true

  tags      = var.common_tags
}

