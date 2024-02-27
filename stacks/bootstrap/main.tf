terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
locals {
  workspace = "${var.pipeline_environment}-bootstrap"
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
  environment_variables = { "name" : "TF_WORKSPACE", "value" : local.workspace }
  github_repo           = "https://github.com/gbbayareametro/doorway-apprunner.git"
  buildspec             = "stacks/infra-pipeline/buildspec.yaml"
  default_tags          = { "App" = "Doorway", "Workspace" = local.workspace }
}


module "log_bucket" {
  source       = "../../modules/s3"
  stack_prefix = local.workspace
  resource_use = "bld-logs"
}
resource "aws_codebuild_project" "codebuild" {
  name          = local.workspace
  description   = "Inital Doorway Application Delivery Bootstrap for ${var.pipeline_environment}"
  build_timeout = 60
  service_role  = aws_iam_role.codebuild_role.arn

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
      location = "${module.log_bucket.bucket.bucket}/logs"
    }
  }

  source {
    type            = "GITHUB"
    location        = local.github_repo
    git_clone_depth = 0
    buildspec       = local.buildspec

  }

  source_version = "main"

  tags = local.default_tags
}
