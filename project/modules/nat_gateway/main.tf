resource "aws_eip" "nat" {
  count = length(var.public_subnet_ids)
  vpc   = true
}

resource "aws_nat_gateway" "gw" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]
  tags          = var.tags
}