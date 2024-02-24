
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
module "artifact_bucket" {
  source     = "../s3"
  stack_prefix = var.stack_prefix
  resource_use = "artifacts"
}
module "log_bucket" {
  source     = "../s3"
  stack_prefix = var.stack_prefix
  resource_use = "bld-logs"
}


resource "aws_codebuild_project" "codebuild" {
  name          = "${var.stack_prefix}-cb-${var.resource_use}"
  description   = var.description
  build_timeout = 5
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type           = "S3"
    location       = module.artifact_bucket.bucket.bucket
    name           = var.output_artifact_name
    namespace_type = "BUILD_ID"
    packaging      = "ZIP"

  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
      }

    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.stack_prefix}-cb-logs"
      stream_name = "${var.stack_prefix}-cb-logs"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${module.log_bucket.bucket.bucket}/logs"
    }
  }

  source {
    type     = "GITHUB"
    location = var.github_repo
    git_clone_depth = 0
    buildspec = var.buildspec
  
  }

  source_version = "main"

  tags = var.default_tags
}
