
module "db_build_job" {
  source                      = "../codebuild"
  log_bucket                  = var.log_bucket
  stack_prefix                = var.stack_prefix
  description                 = "Runs Db Build for Doorway ${var.stack_prefix}"
  allowed_aws_actions         = ["rds:*", "ec2:*", "ssm:*", "secretsmanager:*", "kms:*", "s3:*", "iam:*"]
  resource_name               = var.resource_name
  artifact_encryption_key_arn = var.artifact_encryption_key_arn
  environment_variables = [{ name : "SSM_PARM_ENCRYPTION_ID", value : var.ssm_paraneter_encryption_key_id },
    { name = "DATABASE_NAME", value = var.database_name },
    { name = "DB_SERVER_ID", value = "${var.stack_prefix}-${var.database_server_resource_name}" },
  { name : "WORKSPACE", value = "${var.stack_prefix}-${var.resource_name}" }]
  buildspec         = var.buildspec
  secondary_sources = var.secondary_sources
  build_timeout     = 60
}

