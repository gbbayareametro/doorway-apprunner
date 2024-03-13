module "log_bucket" {
  source        = "../s3"
  stack_prefix  = var.stack_prefix
  resource_name = "bld-logs"
}
resource "aws_codebuild_project" "codebuild" {
  name           = "${var.stack_prefix}-${var.resource_name}"
  description    = var.description
  build_timeout  = var.build_timeout
  service_role   = aws_iam_role.codebuild_role.arn
  encryption_key = var.artifact_encryption_key_arn
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
      group_name  = "${var.stack_prefix}-cb-logs"
      stream_name = "${var.stack_prefix}-cb-logs"
    }
    s3_logs {
      status   = "ENABLED"
      location = "${var.log_bucket}/${var.stack_prefix}-cb-logs"
    }
  }
  tags = var.default_tags
  dynamic "secondary_sources" {
    for_each = toset(var.secondary_sources)
    content {
      type              = "GITHUB"
      location          = secondary_sources.key.source_location
      source_identifier = secondary_sources.key.source_id
    }

  }
}
