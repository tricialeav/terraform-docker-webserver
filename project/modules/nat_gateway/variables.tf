variable "public_subnet_ids" {
  description = "The public subnet ids to assign to the VPC."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "The private subnet ids to assign to the VPC."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}