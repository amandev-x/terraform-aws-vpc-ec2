locals {
  commonTags = {
    ManagedBy   = "Terraform"
    Environment = "Development"
    Author      = "Aman Dabral"
  }
}

resource "aws_vpc" "main-VPC" {
  cidr_block = var.vpc_cidr_block
  tags = merge(local.commonTags, {
    Name = "Main-VPC"
  })
}

# Create all subnets dynamically
resource "aws_subnet" "subnets" {
  vpc_id = aws_vpc.main-VPC.id

  for_each                = var.subnets
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.public

  tags = merge(local.commonTags, {
    Name = each.key
    Type = each.value.public ? "public" : "private"
  })
}


resource "aws_internet_gateway" "main-IGW" {
  vpc_id = aws_vpc.main-VPC.id
  tags = merge(local.commonTags, {
    Name = "Main-IGW"
  })
}

# Create route tables dynamically for public subnets
resource "aws_route_table" "Public-RTB" {
  count = length([for key, value in var.subnets : key if value.public]) > 0 ? 1 : 0

  vpc_id = aws_vpc.main-VPC.id
  route {
    gateway_id = aws_internet_gateway.main-IGW.id
    cidr_block = "0.0.0.0/0"
  }

  tags = merge(local.commonTags, {
    Name = "Public-RTB"
  })
}

# Associate public subnets with public route table
resource "aws_route_table_association" "Public_subnet_association" {
  for_each = {
    for key, value in var.subnets : key => value if value.public
  }

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.Public-RTB[0].id
}

# Create route tables for private subnets (one per AZ for NAT Gateway)
resource "aws_route_table" "Private-RTB" {
  vpc_id = aws_vpc.main-VPC.id

  for_each = {
    for key, value in var.subnets : key => value if !value.public
  }
  tags = merge(local.commonTags, {
    Name = "${each.key}-RTB"
  })
}

# Associate private subnets with their route tables
resource "aws_route_table_association" "Private_subnet_association" {
  for_each = {
    for key, value in var.subnets : key => value if !value.public
  }


  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.Private-RTB[each.key].id
}