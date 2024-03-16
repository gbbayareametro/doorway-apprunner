
module "db_build_job" {
  source     = "../codebuild"
  log_bucket = var.log_bucket

  description                 = "Runs Db server Build for Doorway ${var.database_server_name}"
  allowed_aws_actions         = ["rds:*", "ec2:*", "ssm:*", "secretsmanager:*", "kms:*", "s3:*", "iam:*"]
  name                        = var.name
  artifact_encryption_key_arn = var.artifact_encryption_key_arn
  environment_variables = [{ name : "SSM_PARM_ENCRYPTION_ID", value : var.ssm_paraneter_encryption_key_id },
    { name = "DB_SERVER_ID", value = var.database_server_name },
    { name : "WORKSPACE", value = var.name },
  ]
  buildspec     = var.buildspec
  build_timeout = 60
}

