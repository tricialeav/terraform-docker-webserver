resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = var.tags
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.availability_zones[count.index % length(var.availability_zones)]
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnets[count.index]
  tags                    = merge(var.tags, { type = "public" })
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.availability_zones[count.index % length(var.availability_zones)]
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnets[count.index]
  tags                    = merge(var.tags, { type = "private" })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "public_subnet_rt" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat" {
  count = length(var.public_subnets)
  vpc   = true
}

resource "aws_nat_gateway" "gw" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  tags          = var.tags
}

resource "aws_route_table" "private_rt" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw[count.index].id
  }
  tags = var.tags
}

resource "aws_route_table_association" "private_subnet_rt" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}

resource "aws_vpc_endpoint" "dynamo_db" {
  vpc_id          = aws_vpc.vpc.id
  service_name    = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids = aws_route_table.private_rt[*].id
  tags            = merge(var.tags, { type = "ecs_dynnamo_endpoint" })
}