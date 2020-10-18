output "vpc_id" {
    description = "The VPC ID."
    value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
    description = "The IDs of the public subnets."
    value = {
        for public_subnet in aws_subnet.public_subnets:
            public_subnet.arn => public_subnet.id
    }
}

output "private_subnet_ids" {
    description = "The IDs of the private subnets."
    value = {
        for private_subnet in aws_subnet.private_subnets:
            private_subnet.arn => private_subnet.id
    }
}