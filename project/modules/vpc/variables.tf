variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}
variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults true."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}

variable "subnets" {
  description = "The subnets to assign to the VPC."
  type = list(string)
}

variable "availability_zones" {
  description = "The availabiltiy zone(s) for the subnets."
  type = list(string)
}