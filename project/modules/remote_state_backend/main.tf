# You cannot create a new backend by simply defining this and then
# immediately proceeding to "terraform apply". The S3 backend must
# be bootstrapped according to the simple yet essential procedure in
# https://github.com/cloudposse/terraform-aws-tfstate-backend#usage
module "terraform_state_backend" {
  source        = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=0.26.1"
  namespace     = var.namespace
  stage         = var.stage
  name          = "terraform"
  attributes    = ["tf-state"]
  force_destroy = false
}