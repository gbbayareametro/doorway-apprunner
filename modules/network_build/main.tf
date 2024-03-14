
module "network_build_job" {
  source                      = "../codebuild"
  name                        = var.name
  log_bucket                  = var.log_bucket
  description                 = "Runs Network Build for Doorway VPC ${var.vpc_name}"
  allowed_aws_actions         = ["rds:*", "ec2:*", "ssm:*", "secretsmanager:*", "kms:*", "s3:*", "iam:*"]
  artifact_encryption_key_arn = var.artifact_encryption_key_arn
  environment_variables = [
    { name = "VPC_NAME", value = var.vpc_name },
    { name : "WORKSPACE", value = var.name },
  ]
  buildspec     = var.buildspec
  build_timeout = 60
}

