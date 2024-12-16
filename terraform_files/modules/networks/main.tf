# terraform_files/modules/networks/main.tf
#############################################
# Fetch Default VPC
#############################################
data "aws_vpc" "default" {
  default = true
}

#############################################
# Create a Single Public Subnet in Default VPC
#############################################
resource "aws_subnet" "public" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.192.0/20"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, { Name = "public-subnet", Type = "Public" })
}

#############################################
# Create a Single Private Subnet in Default VPC
#############################################
resource "aws_subnet" "private" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.208.0/20"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = merge(var.common_tags, { Name = "private-subnet", Type = "Private" })
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
# NAT Gateway for Private Subnet
#############################################
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id # Attach NAT Gateway to public subnet

  tags = merge(var.common_tags, { Name = "nat-gateway" })
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  tags = merge(var.common_tags, { Name = "eip-for-nat" })
}

#############################################
# Public Route Table for Public Subnet
#############################################
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = merge(var.common_tags, { Name = "public-rt", Type = "Public" })
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#############################################
# Private Route Table for Private Subnet
#############################################
resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id # Route through NAT Gateway
  }

  tags = merge(var.common_tags, { Name = "private-rt", Type = "Private" })
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
