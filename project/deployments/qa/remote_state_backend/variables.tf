variable "prefix" {
  description = "Project prefix used to name created resources."
  type        = string
  default     = "terraform-docker-webserver"
}

variable "env" {
  description = "The environmennt to deploy resources into."
  type        = string
  default     = "qa"
}