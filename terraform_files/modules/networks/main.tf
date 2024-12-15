#############################################
# Fetch Default VPC
#############################################
data "aws_vpc" "default" {
  default = true
}

#############################################
# Create Public Subnets in Default VPC
#############################################
resource "aws_subnet" "public" {
  for_each           = toset(var.availability_zones) # Loop over availability zones
  vpc_id             = data.aws_vpc.default.id      # Attach to default VPC
  cidr_block         = cidrsubnet(data.aws_vpc.default.cidr_block, 8, index(var.availability_zones, each.key))
  availability_zone  = each.key
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, { Name = "public-subnet-${each.key}", Type = "Public" })
}

#############################################
# Create Private Subnets in Default VPC
#############################################
resource "aws_subnet" "private" {
  for_each           = toset(var.availability_zones) # Loop over availability zones
  vpc_id             = data.aws_vpc.default.id      # Attach to default VPC
  cidr_block         = cidrsubnet(data.aws_vpc.default.cidr_block, 8, index(var.availability_zones, each.key) + length(var.availability_zones))
  availability_zone  = each.key
  map_public_ip_on_launch = false

  tags = merge(var.common_tags, { Name = "private-subnet-${each.key}", Type = "Private" })
}

#############################################
# Use Existing Internet Gateway from Default VPC
#############################################
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#############################################
# NAT Gateway for Private Subnets
#############################################
resource "aws_nat_gateway" "nat" {
  for_each       = toset(var.availability_zones)
  allocation_id  = aws_eip.nat[each.key].id
  subnet_id      = aws_subnet.public[each.key].id # Attach NAT Gateway to public subnets

  tags = merge(var.common_tags, { Name = "nat-gateway-${each.key}" })
}

# Elastic IP for NAT Gateways
resource "aws_eip" "nat" {
  for_each = toset(var.availability_zones)

  tags = merge(var.common_tags, { Name = "eip-for-nat-${each.key}" })
}

#############################################
# Public Route Table for Public Subnets
#############################################
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id # Use default Internet Gateway
  }

  tags = merge(var.common_tags, { Name = "public-rt", Type = "Public" })
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  for_each       = toset(var.availability_zones)
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

#############################################
# Private Route Table for Private Subnets
#############################################
resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[each.key].id # Route through NAT Gateway
  }

  tags = merge(var.common_tags, { Name = "private-rt", Type = "Private" })
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  for_each       = toset(var.availability_zones)
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
