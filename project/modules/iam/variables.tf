variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}

variable "dynamodb_table_name" {
  descripton = "The name of the ECS DynamoDB table."
  type       = string
}