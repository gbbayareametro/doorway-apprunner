
################################################################################
# VPC Module
################################################################################
locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}
data "aws_availability_zones" "available" {

}
# trunk-ignore(checkov/CKV_TF_1): main registry doesn't version by hash
module "vpc" {
  source                = "terraform-aws-modules/vpc/aws"
  version               = "~>5.1"
  name                  = var.name
  cidr                  = var.cidr
  azs                   = local.azs
  private_subnets       = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k)]
  public_subnets        = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 4)]
  database_subnets      = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 8)]
  database_subnet_names = [for k, v in local.azs : "${var.name}-db-${k}"]
}
