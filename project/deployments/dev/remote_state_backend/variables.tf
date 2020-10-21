variable "prefix" {
  description = "Project prefix used to name created resources."
  type        = string
  default     = "terraform-docker-webserver"
}

variable "env" {
  description = "The environment to deploy resources into."
  type        = string
  default     = "dev"
}