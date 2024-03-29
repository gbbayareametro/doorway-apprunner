

module "tf_state_bucket" {
  source = "../../modules/s3"
  name   = "${var.name}-artifacts"
}

module "log_bucket" {
  source = "../../modules/s3"
  name   = "${var.name}-logs"
}

data "aws_codestarconnections_connection" "github" {
  name = "doorway-github-connection"
}
locals {
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)
  cidr = "10.0.0.0/16"
}
data "aws_availability_zones" "available" {

}
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
#trunk-ignore(checkov/CKV2_AWS_5)
resource "aws_security_group" "egress_to_internet" {
  for_each    = toset(var.build_envs)
  name        = "allow internet egress"
  vpc_id      = module.vpc[each.key].vpc_id
  description = "This will allow access to internet resources from within the VPC"


}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  for_each          = toset(var.build_envs)
  security_group_id = aws_security_group.egress_to_internet[each.key].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  description       = "allow outbound ipv4 traffic"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  for_each          = toset(var.build_envs)
  security_group_id = aws_security_group.egress_to_internet[each.key].id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  description       = "allow outbound ipv6 traffic"
}
# trunk-ignore(checkov/CKV_TF_1): global terraform registry doesn't use commit hash versioning
module "kms" {
  for_each    = toset(var.build_envs)
  source      = "terraform-aws-modules/kms/aws"
  version     = "2.2.0"
  description = "Encryption Key for${var.app_name}-${each.value} database parameters"
}
# module "network_build" {
#   for_each      = toset(var.build_envs)
#   source        = "../network_build"
#   name          = "${var.app_name}-${each.key}-network"
#   pipeline_name = var.name
#   app_name      = var.app_name
#   log_bucket    = module.log_bucket.bucket
#   environment   = each.key
# }
module "db_build" {
  for_each      = toset(var.build_envs)
  source        = "../../modules/db_build"
  log_bucket    = module.log_bucket.bucket
  name          = "${var.app_name}-${each.key}-db-build"
  pipeline_name = var.name
  app_name      = var.app_name
  environment   = each.key
}
module "db_migrator" {
  for_each      = toset(var.build_envs)
  source        = "../db_migrator"
  name          = "${var.app_name}-${each.key}-db-migration"
  environment   = each.key
  pipeline_name = var.name
  log_bucket    = module.log_bucket.bucket
  vpcs = [{
    vpc_id             = module.vpc[each.key].vpc_id
    subnets            = module.vpc[each.key].private_subnets
    security_group_ids = [aws_security_group.egress_to_internet[each.key].id]
  }]
}
resource "aws_codepipeline" "infra-pipeline" {
  role_arn = aws_iam_role.codepipeline_role.arn
  name     = var.name
  artifact_store {
    location = module.tf_state_bucket.bucket
    type     = "S3"
    encryption_key {
      id   = module.tf_state_bucket.encryption_key_arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "InfraSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["infra-source"]
      configuration = {
        ConnectionArn    = data.aws_codestarconnections_connection.github.arn
        FullRepositoryId = var.infra_source_repo
        BranchName       = var.infra_source_branch
      }


    }
    # action {
    #   name             = "DoorwaySource"
    #   category         = "Source"
    #   owner            = "AWS"
    #   provider         = "CodeStarSourceConnection"
    #   version          = "1"
    #   output_artifacts = ["doorway-source"]
    #   configuration = {
    #     ConnectionArn    = data.aws_codestarconnections_connection.github.arn
    #     FullRepositoryId = var.doorway_source_repo
    #     BranchName       = var.doorway_source_branch
    #   }

    # }
  }
  dynamic "stage" {
    for_each = var.build_envs
    content {
      name = stage.value
      action {
        name            = "Database"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["infra-source"]
        version         = "1"
        run_order       = 2
        configuration = {
          ProjectName = module.db_build[var.build_envs[stage.key]].name
        }
      }
      action {
        name            = "DatabaseMigration"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["infra-source"]
        version         = "1"
        run_order       = 3
        configuration = {
          ProjectName = module.db_migrator[var.build_envs[stage.key]].name
        }
      }
    }

  }
}
