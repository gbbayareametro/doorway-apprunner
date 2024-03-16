locals {


  tags = {
    Name        = var.name
    Application = var.app_user
  }
}

################################################################################
# PostgreSQL Serverless v2
################################################################################
data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "16.1"
}
data "aws_vpc" "vpc" {
  id = var.vpc_id

}
# trunk-ignore(checkov/CKV_TF_1): git hashes arent used by main terraform registry
module "aurora_postgresql_v2" {
  source               = "terraform-aws-modules/rds-aurora/aws"
  version              = "~>9.1"
  name                 = var.name
  engine               = data.aws_rds_engine_version.postgresql.engine
  engine_mode          = "provisioned"
  engine_version       = data.aws_rds_engine_version.postgresql.version
  storage_encrypted    = true
  master_username      = var.master_username
  vpc_id               = data.aws_vpc.vpc.id
  db_subnet_group_name = var.database_subnet_group
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = data.aws_vpc.vpc.cidr_block
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

