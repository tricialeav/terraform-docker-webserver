variable "region" {
  description = "The region used to deploy resources."
  type        = string
}

variable "prefix" {
  description = "Project prefix used to name created resources."
  type        = string
}

variable "env" {
  description = "The environmennt to deploy resources into."
  type        = string
}

variable "enabled" {
  description = "Flag to enable resources."
  type        = bool
}

variable "dynamodb_table_name" {
  description = "The name of the ECS DynamoDB table."
  type        = string
}