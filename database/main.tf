terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 5"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
  default_tags { tags = var.default_tags }
}
locals {
  name = "${var.app_name}-${var.environment}-db"
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "aurora_postgresql" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.1.0"


  name              = local.name
  engine            = "aurora-postgresql"
  engine_mode       = "serverless"
  storage_encrypted = true
  master_username   = "root"

  vpc_id               = var.vpc_id
  db_subnet_group_name = var.database_subnet_group_name
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = var.database_subnets_cidr_blocks
    }
  }

  # Serverless v1 clusters do not support managed master user password
  manage_master_user_password = false
  master_password             = random_password.password.result

  monitoring_interval = 60

  preferred_maintenance_window = "sun:02:00-sun:04:00"
  skip_final_snapshot          = true

  # enabled_cloudwatch_logs_exports = # NOT SUPPORTED

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 2
    max_capacity             = 16
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
  # db_cluster_parameter_group_name        = local.name
  # db_cluster_parameter_group_family      = "aurora-postgresql14"
  # db_cluster_parameter_group_description = "${local.name} example cluster parameter group"
  # db_cluster_parameter_group_parameters = [
  #   {
  #     name         = "log_min_duration_statement"
  #     value        = 4000
  #     apply_method = "immediate"
  #     }, {
  #     name         = "rds.force_ssl"
  #     value        = 1
  #     apply_method = "immediate"
  #   }
  # ]

  # create_db_parameter_group      = true
  # db_parameter_group_name        = local.name
  # db_parameter_group_family      = "aurora-postgresql14"
  # db_parameter_group_description = "${local.name} example DB parameter group"
  # db_parameter_group_parameters = [
  #   {
  #     name         = "log_min_duration_statement"
  #     value        = 4000
  #     apply_method = "immediate"
  #   }
  # ]

  # enabled_cloudwatch_logs_exports = ["postgresql"]
  create_cloudwatch_log_group     = true

  tags                                  = var.default_tags
  create_db_cluster_activity_stream     = true
  db_cluster_activity_stream_kms_key_id = module.kms.key_id
  db_cluster_activity_stream_mode       = "async"
}
module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.0"

  deletion_window_in_days = 7
  description             = "KMS key for ${var.app_name}-${var.environment}-db cluster activity stream."
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"

  aliases = [local.name]

  tags = var.default_tags
}
