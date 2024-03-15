terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
locals {
  workspace = "${var.pipeline_name}-bootstrap"
  allowed_aws_actions = [
    "ec2:CreateNetworkInterface",
    "ec2:DescribeDhcpOptions",
    "ec2:DescribeNetworkInterfaces",
    "ec2:DeleteNetworkInterface",
    "ec2:DescribeSubnets",
    "ec2:DescribeSecurityGroups",
    "ec2:DescribeVpcs",
    "ec2:DescribeAvailabilityZones",
    "rds:*",
    "kms:*",
    "iam:*",
    "ec2:CreateVpc",
    "ec2:CreateTags",
    "ec2:*",
    "secretsmanager:*"
  ]
  environment_variables = { "WORKSPACE" : local.workspace, "PIPELINE_NAME" : var.pipeline_name, "TF_STATE_BUCKET" : module.artifact_bucket.bucket }
}
module "log_bucket" {
  source = "../../modules/s3"
  name   = "${var.app_name}-${var.pipeline_name}-bootstrap-logs"
}
module "artifact_bucket" {
  source = "../../modules/s3"
  name   = "${var.app_name}-${var.pipeline_name}-bootstrap-artifacts"
}
resource "aws_codebuild_project" "codebuild" {
  name           = local.workspace
  description    = "Inital Doorway Application Delivery Bootstrap for ${var.pipeline_name}"
  build_timeout  = 60
  service_role   = aws_iam_role.codebuild_role.arn
  encryption_key = module.artifact_bucket.encryption_key_arn
  artifacts {
    type     = "S3"
    location = module.artifact_bucket.bucket
    path     = "/"
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
