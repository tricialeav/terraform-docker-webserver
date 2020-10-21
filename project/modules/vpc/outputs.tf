output "vpc_id" {
  description = "The VPC ID."
  value       = aws_vpc.vpc.id
}

output "vpc_cidr" {
  description = "The VPC CIDR block."
  value       = aws_vpc.vpc.cidr
}

# output "public_subnet_ids" {
#   description = "The IDs of the public subnets."
#   value = aws_subnet.public_subnets.*.id
# }

# output "private_subnet_ids" {
#   description = "The IDs of the private subnets."
#   value = aws_subnet.private_subnets.*.id
# }