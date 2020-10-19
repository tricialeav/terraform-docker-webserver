data "aws_subnet" "public_subnets" {
  tags = {
    type = "public"
  }
}

data "aws_subnet" "private_subnets" {
  tags = {
    type = "private"
  }
}

resource "aws_eip" "nat" {
  count = length(data.aws_subnet.public_subnets)
  vpc   = true
}

resource "aws_nat_gateway" "gw" {
  count         = length(data.aws_subnet.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = data.aws_subnet.public_subnets[count.index].id
  tags          = var.tags
}