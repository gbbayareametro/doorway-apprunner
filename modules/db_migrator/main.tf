
module "db_migrator_job" {
  source              = "../codebuild"
  log_bucket          = var.log_bucket
  name                = var.name
  description         = "Runs Db Migration for Doorway"
  allowed_aws_actions = ["secretsmanager:*", "ec2:*"]
  environment_variables = [{ name = "WORKSPACE", value = var.name },
    { name = "PIPELINE_NAME", value = var.pipeline_name },
    { name = "APP_NAME", value = var.app_name },
  { name = "ENVIRONMENT", value = var.environment }, ]
  buildspec         = "./modules/db_migrator/buildspec.yaml"
  secondary_sources = var.secondary_sources
  vpcs              = var.vpcs
}
