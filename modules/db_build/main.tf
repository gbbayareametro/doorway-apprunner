
module "db_build_job" {
  source                      = "../codebuild"
  log_bucket                  = var.log_bucket
  log_bucket_arn              = var.log_bucket_arn
  stack_prefix                = var.stack_prefix
  description                 = "Runs Db Build for Doorway ${var.stack_prefix}"
  allowed_aws_actions         = ["rds:*", "ec2:*", "ssm:*", "secretsmanager:*", "kms:*", "s3:*", "iam:*"]
  name                        = var.name
  artifact_encryption_key_arn = var.artifact_encryption_key_arn
  environment_variables       = [{ name : "SSM_PARM_ENCRYPTION_ID", value : var.ssm_paraneter_encryption_key_id }]
  buildspec                   = var.buildspec
  secondary_sources           = var.secondary_sources
  build_timeout               = 60
}

