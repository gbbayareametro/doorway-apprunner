
module "db_migrator_job" {
  source                      = "../codebuild"
  log_bucket                  = var.log_bucket
  stack_prefix                = var.stack_prefix
  description                 = "Runs Db Migration for Doorway"
  allowed_aws_actions         = ["secretsmanager:*"]
  resource_name               = var.resource_name
  artifact_encryption_key_arn = var.artifact_encryption_key_arn
  environment_variables = [{ name : "STACK_PREFIX", value : var.stack_prefix },
    { name = "DB_SERVER_ID", value = var.db_server_id },
  { name = "DATABASE_NAME", value = var.database_name }]
  build_image_url   = "aws/codebuild/amazonlinux-aarch64-lambda-standard:nodejs18"
  environment_type  = "ARM_LAMBDA_CONTAINER"
  compute_type      = "BUILD_LAMBDA_1GB"
  buildspec         = "./modules/db_migrator/buildspec.yaml"
  secondary_sources = var.secondary_sources
}
