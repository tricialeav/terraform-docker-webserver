data "aws_subnet" "public" {
  tags = {
    type = "public"
  }
}

resource "aws_eip" "nat" {
  count = length(data.aws_subnet.public)
  vpc   = true
}

resource "aws_nat_gateway" "gw" {
  count         = length(data.aws_subnet.public)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = data.aws_subnet.public.id[count.index]
  tags          = var.tags
}