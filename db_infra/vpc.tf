locals {
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)
  cidr = "10.0.0.0/16"
}
data "aws_availability_zones" "available" {

}
# trunk-ignore(checkov/CKV_TF_1): main registry doesn't version by hash
module "vpc" {
  source                             = "terraform-aws-modules/vpc/aws"
  version                            = "~>5.1"
  name                               = "${var.app_name}-${var.environment}"
  cidr                               = local.cidr
  azs                                = local.azs
  create_database_subnet_route_table = true
  enable_nat_gateway                 = true
  private_subnets                    = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k)]
  public_subnets                     = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k + 4)]
  database_subnets                   = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k + 8)]
  database_subnet_names              = [for k, v in local.azs : "${local.db_name}-db-${k}"]
}
