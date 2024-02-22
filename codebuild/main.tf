
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
  stack      = var.stack
  bucket_use = "codebuild-art"
}
module "log_bucket" {
  source     = "../s3"
  stack      = var.stack
  bucket_use = "codebuild-log"
}


resource "aws_codebuild_project" "codebuild" {
  name          = "${var.app_name}-${var.environment}-${var.stack}-${var.project_use}"
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
      group_name  = "${var.app_name}-${var.environment}-${var.stack}-codebuild-loggroup"
      stream_name = "${var.app_name}-${var.environment}-${var.stack}-codebuild-logstream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${module.log_bucket.bucket.bucket}/logs"
    }
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/gbbayareametro/doorway-apprunner.git"
    git_clone_depth = 0
  
  }

  source_version = "main"

  tags = var.default_tags
}
