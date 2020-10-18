resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = var.tags
}

resource "aws_subnet" "subnet" {
  count                   = length(var.subnets)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.availability_zones[count.index % length(var.availability_zones)]
  map_public_ip_on_launch = count.index % length(var.availability_zones) == 0 ? true : false
  cidr_block              = var.subnets[count.index]
  tags                    = count.index % length(var.availability_zones) == 0 ? merge(var.tags, {type = "public"}) : merge(var.tags, {type = "private"})

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
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}