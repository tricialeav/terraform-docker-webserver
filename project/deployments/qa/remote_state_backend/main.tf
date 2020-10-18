module "remote_state_backend" {
  source    = "../../../modules/remote_state_backend"
  namespace = var.prefix
  stage     = var.env
}