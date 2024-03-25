# trunk-ignore(checkov/CKV_TF_1): main registry doesn't version by hash
module "vpc" {
  for_each                           = toset(var.build_envs)
  source                             = "terraform-aws-modules/vpc/aws"
  version                            = "~>5.1"
  name                               = "${var.app_name}-${each.key}"
  cidr                               = local.cidr
  azs                                = local.azs
  create_database_subnet_route_table = true
  enable_nat_gateway                 = true
  private_subnets                    = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k)]
  public_subnets                     = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k + 4)]
  database_subnets                   = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k + 8)]
  database_subnet_names              = [for k, v in local.azs : "${var.name}-db-${k}"]
}

