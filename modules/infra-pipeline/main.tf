
locals {
  stack_prefix = "${var.app_name}-${var.pipeline_environment}-infra-pipeline"
}
module "artifact_bucket" {
  source       = "../../modules/s3-no-prefix"
  stack_prefix = local.stack_prefix
  name         = "artifacts"
}
module "log_bucket" {
  source       = "../../modules/s3"
  stack_prefix = local.stack_prefix
  name         = "logs"
}
data "aws_codestarconnections_connection" "github" {
  name = "doorway-github-connection"
}

module "db_build" {
  for_each                    = toset(var.build_envs)
  source                      = "../codebuild"
  log_bucket                  = module.log_bucket.bucket
  description                 = "Creates the database for ${local.stack_prefix}"
  stack_prefix                = "${var.app_name}-${each.value}"
  artifact_encryption_key_arn = module.artifact_bucket.encryption_key_arn
  buildspec                   = "./stacks/database/buildspec.yaml"
  environment_variables = [{ name : "WORKSPACE", value : "${var.app_name}-${each.value}-db" },
  { name : "PIPELINE_ENV", value : var.pipeline_environment }]
  log_bucket_arn      = module.log_bucket.arn
  allowed_aws_actions = ["rds:*", "ec2:*", "ssm:*", "secretsmanager:*", "kms:*", "s3:*", "iam:*"]
  build_timeout       = 60
}
module "db_migrator" {
  for_each                    = toset(var.build_envs)
  source                      = "../db_migrator"
  stack_prefix                = "${var.app_name}-${each.value}"
  log_bucket                  = module.log_bucket.bucket
  log_bucket_arn              = module.log_bucket.arn
  artifact_encryption_key_arn = module.artifact_bucket.encryption_key_arn
}
resource "aws_codepipeline" "infra-pipeline" {
  role_arn = aws_iam_role.codepipeline_role.arn
  name     = local.stack_prefix
  artifact_store {
    location = module.artifact_bucket.bucket
    type     = "S3"
    encryption_key {
      id   = module.artifact_bucket.encryption_key_arn
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
    action {
      name             = "DoorwaySource"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["doorway-source"]
      configuration = {
        ConnectionArn    = data.aws_codestarconnections_connection.github.arn
        FullRepositoryId = var.doorway_source_repo
        BranchName       = var.doorway_source_branch
      }
    }
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
        configuration = {
          ProjectName = module.db_build[var.build_envs[stage.key]].name
        }
      }
      action {
        name            = "DatabaseMigration"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["doorway-source"]
        version         = "1"
        configuration = {
          ProjectName = module.db_migrator[var.build_envs[stage.key]].name
        }
      }
    }

  }
}
