output "vpc_id" {
  description = "The VPC ID."
  value       = aws_vpc.vpc.id
}

output "vpc_cidr" {
  description = "The VPC CIDR block."
  value       = aws_vpc.vpc.cidr_block
}