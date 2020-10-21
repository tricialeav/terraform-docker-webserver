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

variable "container_name" {
  description = "The name to use fo rthe ECS container."
  type        = string
}

variable "port_mappings" {
  description = "The port mappings to configure for the container."
  type        = list(map(string))
}

variable "essential" {
  description = "Determines whether all other containers in a task are stopped, if this container fails or stops for any reason. Due to how Terraform type casts booleans in json it is required to double quote this value."
  type        = string
}

variable "log_driver" {
  description = "Log driver option to send to a custom log driver for the container."
  type        = string
}