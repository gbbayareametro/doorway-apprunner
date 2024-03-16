
module "network_build_job" {
  source                      = "../codebuild"
  name                        = var.name
  log_bucket                  = var.log_bucket
  description                 = "Runs Network Build for Doorway VPC ${var.vpc_name}"
  allowed_aws_actions         = ["rds:*", "ec2:*", "ssm:*", "secretsmanager:*", "kms:*", "s3:*", "iam:*"]
  artifact_encryption_key_arn = var.artifact_encryption_key_arn
  environment_variables = [
    { name = "VPC_NAME", value = var.vpc_name },
    { name = "WORKSPACE", value = var.name },
    { name = "KMS_KEY", value = var.artifact_encryption_key_arn },
    { name = "TF_STATE_BUCKET", value = var.artifact_bucket }

  ]
  buildspec     = var.buildspec
  build_timeout = 60
}

