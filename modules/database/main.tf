locals {
  name     = "${var.stack_prefix}-${var.resource_name}"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-rds-aurora"
    GithubOrg  = "terraform-aws-modules"
  }
}
data "aws_availability_zones" "available" {}
################################################################################
# PostgreSQL Serverless v2
################################################################################
data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "16.1"
}
# trunk-ignore(checkov/CKV_TF_1): git hashes arent used by main terraform registry
module "aurora_postgresql_v2" {
  source               = "terraform-aws-modules/rds-aurora/aws"
  version              = "9.1.0"
  name                 = local.name
  engine               = data.aws_rds_engine_version.postgresql.engine
  engine_mode          = "provisioned"
  engine_version       = data.aws_rds_engine_version.postgresql.version
  storage_encrypted    = true
  master_username      = var.db_master_user
  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }
  monitoring_interval = 60
  apply_immediately   = true
  skip_final_snapshot = true
  serverlessv2_scaling_configuration = {
    min_capacity = 2
    max_capacity = 10
  }
  instance_class = "db.serverless"
  instances = {
    one = {}
    two = {}
  }
  tags = local.tags
}
################################################################################
# Supporting Resources
################################################################################
resource "random_password" "master" {
  length  = 20
  special = false
}
# trunk-ignore(checkov/CKV_TF_1): git hashes arent used by main terraform registry
module "vpc" {
  source           = "terraform-aws-modules/vpc/aws"
  version          = "~> 5.0"
  name             = "${var.stack_prefix}-vpc"
  cidr             = local.vpc_cidr
  azs              = local.azs
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 3)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 6)]
  tags             = local.tags
}
resource "postgresql_database" "create_database" {
  name  = var.database_name
  owner = var.db_master_user
}