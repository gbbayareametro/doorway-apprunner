terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}
provider "aws" {
  region = module.global.default_aws_region
}

locals {
  stack_prefix = "${var.pipeline_environment}-pipeline"
}
module "artifact_bucket" {
  source       = "../../modules/s3"
  stack_prefix = local.stack_prefix
  resource_use = "artifacts"
}
module "log_bucket" {
  source       = "../../modules/s3"
  stack_prefix = local.stack_prefix
  resource_use = "logs"
}
resource "aws_codestarconnections_connection" "github" {
  name          = "${local.stack_prefix}-github"
  provider_type = "GitHub"
}
module "dev_db_build" {
  source                      = "../../modules/codebuild"
  log_bucket                  = module.log_bucket.bucket
  description                 = "Creates the database for ${local.stack_prefix}"
  stack_prefix                = "${var.app_name}-dev-db"
  artifact_encryption_key_arn = module.artifact_bucket.encryption_key_arn
  resource_use                = "db"

  allowed_aws_actions = ["rds:*", "ec2:*", "ssm:*", "secretsmanager:*", "kms:*"]
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
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = var.source_repo
        BranchName       = var.source_branch
      }
    }
  }

  stage {
    name = "Dev"
    action {
      name            = "Database"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"

      configuration = {
        ProjectName = "${var.app_name}-dev-db"
      }
    }
  }
}