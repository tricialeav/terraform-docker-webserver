terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

locals {
  tags = {
    name = var.prefix
    env  = var.env
  }
}

module "iam" {
  count               = var.enabled ? 1 : 0
  source              = "./iam"
  tags                = local.tags
  dynamodb_table_name = var.dynamodb_table_name
  ecr_name            = modules.ecr.ecr_name
}

module "vpc" {
  count                = var.enabled ? 1 : 0
  source               = "./vpc"
  region               = var.region
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  availability_zones   = ["us-west-2a", "us-west-2b"]
  public_subnets       = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets      = ["10.0.2.0/24", "10.0.3.0/24"]
  tags                 = local.tags
}

# module "ecs" {
#   count           = var.enabled ? 1 : 0
#   source          = "./ecs"
#   tags            = local.tags
#   vpc_id          = module.vpc.vpc_id
#   vpc_cidr        = module.vpc.vpc_cidr
#   container_image = "ubuntu"
#   container_name  = "web-app"
#   port_mappings = [
#     {
#       "containerPort" : 8080,
#       "hostPort" : 8080,
#       "protocol" : "http"
#     }
#   ]
#   log_configuration = {
#     logDriver = "awslogs"
#     options = {
#       awslogs-group         = ""
#       awslogs-region        = var.region
#       awslogs-stream-prefix = "awslogs-mythicalmysfits-service"
#     }
#     essential = true
#   }
# }