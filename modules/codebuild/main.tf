#trunk-ignore(checkov/CKV_AWS_147): No artifacts being passed at this point
resource "aws_codebuild_project" "codebuild" {
  name          = var.name
  description   = var.description
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = var.compute_type
    image                       = var.build_image_url
    type                        = var.environment_type
    image_pull_credentials_type = "CODEBUILD"
    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
      }
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "${var.log_bucket}-${var.name}"
      stream_name = "${var.log_bucket}-${var.name}"
    }
    s3_logs {
      status   = "ENABLED"
      location = "${var.log_bucket}/${var.name}"
    }
  }

  dynamic "secondary_sources" {
    for_each = toset(var.secondary_sources)
    content {
      type              = "GITHUB"
      location          = secondary_sources.key.source_location
      source_identifier = secondary_sources.key.source_id
    }
  }
  dynamic "vpc_config" {
    for_each = var.vpcs
    content {
      vpc_id             = vpc_config.vpc_id
      subnets            = vpc_config.subnets
      security_group_ids = vpc_config.security_group_ids
    }

  }
}
