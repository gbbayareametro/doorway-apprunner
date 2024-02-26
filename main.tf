
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
    kms_key_id = "arn:aws:kms:us-west-2:364076391763:key/965d66d2-a23f-4159-84a9-bf040e0b9e66"
  }
}

module "database" {
  source = "./modules/rds-aurora"
}