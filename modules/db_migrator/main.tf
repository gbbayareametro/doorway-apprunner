
module "db_migrator_job" {
  source              = "../codebuild"
  log_bucket          = var.log_bucket
  name                = var.name
  description         = "Runs Db Migration for Doorway"
  allowed_aws_actions = ["secretsmanager:*"]
  environment_variables = [{ name = "WORKSPACE", value = var.name },
    { name = "PIPELINE_NAME", value = var.pipeline_name },
    { name = "APP_NAME", value = var.app_name },
  { name = "ENVIRONMENT", value = var.environment }, ]
  buildspec         = "./modules/db_migrator/buildspec.yaml"
  secondary_sources = var.secondary_sources
  vpcs = [{
    vpc_id             = data.aws_vpc.vpc.id,
    subnets            = data.aws_subnets.private.ids
    security_group_ids = data.aws_security_groups.groups.ids

  }]
}
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.app_name}/pipelines/${var.pipeline_name}/${var.environment}/vpc_id"
}

data "aws_vpc" "vpc" {
  id = data.aws_ssm_parameter.vpc_id.value
}
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-${var.environment}-private-*"]
  }
}
data "aws_security_groups" "groups" {
  filter {
    name   = "group-name"
    values = ["${var.app_name}-${var.environment}*"]
  }


}
