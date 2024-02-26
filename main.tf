
# module "apprunner" {
#   source = "./apprunner"
# }

# module "network" {
#   source = "./network"
# }
terraform {
  backend "s3" {
    bucket         = "dw-dev-bootstrap-s3-artifacts20240226000651036500000001"
    key            = "terraform/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}

module "database" {
  source = "./modules/rds-aurora"
}