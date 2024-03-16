
module "network_build_job" {
  source              = "../codebuild"
  name                = var.name
  log_bucket          = var.log_bucket
  description         = "Runs Network Build for Doorway VPC for the ${var.environment} environment"
  allowed_aws_actions = ["ec2:*", "ssm:*", "kms:*", "s3:*", "iam:*"]
  environment_variables = [
    { name = "WORKSPACE", value = var.name },
    { name = "PIPELINE_NAME", value = var.pipeline_name },
    { name = "APP_NAME", value = var.app_name },
    { name = "ENVIRONMENT", value = var.environment },
  ]
  buildspec     = var.buildspec
  build_timeout = 60
}

