module "db_migrator_job" {
  source                      = "../codebuild"
  log_bucket                  = var.log_bucket
  log_bucket_arn              = var.log_bucket_arn
  stack_prefix                = var.stack_prefix
  description                 = "Runs Db Migration for Doorway"
  allowed_aws_actions         = ["secretsmanager:*"]
  name                        = var.name
  artifact_encryption_key_arn = var.artifact_encryption_key_arn
  environment_variables       = []
  build_image_url             = "aws/codebuild/amazonlinux-aarch64-lambda-standard:nodejs18"
  environment_type            = "ARM_LAMBDA_CONTAINER"
  compute_type                = "BUILD_LAMBDA_1GB"
}
