locals {
  db_name = "${var.app_name}-${var.environment}"
}

################################################################################
# PostgreSQL Serverless v2
################################################################################
data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "16.1"
}
data "aws_vpc" "default_vpc" {
  default = true
}

# trunk-ignore(checkov/CKV_TF_1): git hashes arent used by main terraform registry
module "aurora_postgresql_v2" {
  source               = "terraform-aws-modules/rds-aurora/aws"
  version              = "~>9.1"
  name                 = local.db_name
  engine               = data.aws_rds_engine_version.postgresql.engine
  engine_mode          = "provisioned"
  engine_version       = data.aws_rds_engine_version.postgresql.version
  storage_encrypted    = true
  master_username      = var.master_username
  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = [concat(
        module.vpc.database_subnets_cidr_blocks,
        module.vpc.private_subnets_cidr_blocks,
        [data.aws_vpc.default_vpc.cidr_block])
      ]



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

}
################################################################################
# Supporting Resources
################################################################################
resource "random_password" "master" {
  length  = 20
  special = false
}

