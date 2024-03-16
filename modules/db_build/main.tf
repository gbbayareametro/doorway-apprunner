
module "db_build_job" {
  source     = "../codebuild"
  log_bucket = var.log_bucket

  description         = "Runs Db server Build for Doorway ${var.environment} environment."
  allowed_aws_actions = ["rds:*", "ec2:*", "ssm:*", "secretsmanager:*", "kms:*", "s3:*", "iam:*"]
  name                = var.name
  environment_variables = [
    { name : "WORKSPACE", value = var.name },
    { name = "PIPELINE_NAME", value = var.pipeline_name },
    { name = "APP_NAME", value = var.app_name },
    { name = "ENVIRONMENT", value = var.environment },
  ]
  buildspec     = var.buildspec
  build_timeout = 60
}
