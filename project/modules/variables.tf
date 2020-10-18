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

variable "backend_state_bucket" {
  description = "The S3 bucket targeted for the environment's backend state file."
  type        = string
}

variable "dynamo_state_lock" {
  description = "The name of the DynamoDB state lock table for Terraform remote backend."
  type        = string
}