variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIODR block of the VPC."
  type        = string
}

variable "container_image" {
  description = "The ECR Image to use for the container."
  type        = string
}