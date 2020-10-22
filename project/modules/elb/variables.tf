variable "lb_name" {
  description = "The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen."
  type        = string
}

variable "lb_internal" {
  description = "If true, the LB will be internal."
  type        = bool
}

variable "lb_type" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
}

variable "lb_subnets" {
  description = "A list of subnet IDs to attach to the LB. Updates on type network forces a recreation of the resource."
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "tg_port" {
  description = "The port on which targets receive traffic, unless overridden when registering a specific target. Required when target_type is instance or ip. Does not apply when target_type is lambda."
  type        = number
}

variable "tg_protocol" {
  descirption = "The protocol to use for routing traffic to the targets. Should be one of \"TCP\", \"TLS\", \"UDP\", \"TCP_UDP\", \"HTTP\" or \"HTTPS\". Required when target_type is instance or ip. Does not apply when target_type is lambda."
  type        = string
}

variable "target_type" {
  description = "The type of target that you must specify when registering targets with this target group. The possible values are instance (targets are specified by instance ID) or ip (targets are specified by IP address) or lambda (targets are specified by lambda arn). "
  type        = string
}

variable "health_check" {
  description = "Health check configuration settings."
  type        = map(any)
}