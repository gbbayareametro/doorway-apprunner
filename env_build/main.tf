terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
locals {
  workspace = "${var.app_name}-env-build"
  allowed_aws_actions = [
    "ec2:*",
    "rds:*",
    "kms:*",
    "iam:*",
    "ec2:CreateVpc",
    "ec2:CreateTags",
    "ec2:*",
    "secretsmanager:*",
    "ssm:*",
    "s3:*",
    "cloudfront:*",
    "apprunner:*"
  ]
  environment_variables = { "WORKSPACE" : local.workspace, "TF_STATE_BUCKET" : module.tf_state_bucket.bucket,
  "TF_STATE_KEY" : module.tf_state_bucket.encryption_key_arn, "ENVIRONMENT" : "dev", "APP_NAME" : var.app_name }
}
module "log_bucket" {
  source = "../modules/s3"
  name   = "${local.workspace}-logs"
}
module "tf_state_bucket" {
  source = "../modules/s3"
  name   = "${local.workspace}-tfstate"
}
resource "aws_codebuild_project" "codebuild" {
  name           = local.workspace
  description    = "Builds a ${var.app_name} environment"
  build_timeout  = 60
  service_role   = aws_iam_role.codebuild_role.arn
  encryption_key = module.tf_state_bucket.encryption_key_arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    dynamic "environment_variable" {
      for_each = local.environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "${local.workspace}-cb-logs"
      stream_name = "${local.workspace}-cb-logs"
    }
    s3_logs {
      status   = "ENABLED"
      location = "${module.log_bucket.arn}/logs"
    }
  }
  source {
    type            = "GITHUB"
    location        = var.github_repo
    git_clone_depth = 0
    buildspec       = var.buildspec
  }
  source_version = "main"
}
