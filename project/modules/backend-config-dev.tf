bucket         = "terraform-docker-webserver-dev-terraform-tf-state"
key            = "deployments/environments/dev/project/terraform.tfstate"
region         = "us-west-2"
encrypt        = true
dynamodb_table = "terraform-docker-webserver-dev-terraform-tf-state-lock"