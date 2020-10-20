# Introduction

**Project is in development**

This repo contains code to deploy the required AWS infrastructure for a web application. **Please note that not all of the below services qualify for free-tier usage. See https://aws.amazon.com/pricing/ for more information.** Main components include: 

1. AWS VPC, including two public and two private subnets spanning two Availability Zones
    - Internet Gateway
    - NAT Gateway
    - Public and Private Route Tables with corresponding routes
    - Two EIPs connected to the pubic subnets
    - DynamoDB Endpoint
2. AWS ECS
    - IAM roles for ECS Services and Tasks

# Requirements

1. Terraform local install: https://www.terraform.io/downloads.html
2. Docker local install: https://docs.docker.com/get-docker/

# Assumptions

1. Users have admin access to their own GitHub account in order to use and run GitHub Actions via workflow files.
2. Users have set up their own AWS account, and have created a role that has permissions to deploy resources: 
https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create.html
2. Users have set up their own AWS Access Key ID and Secret Access Key in GitHub Secrets: https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets
