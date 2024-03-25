
resource "aws_ssm_parameter" "db_host" {
  name        = "/${var.app_name}/${var.environment}/db/host"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_endpoint
  description = "the ${var.app_name} ${var.environment} DB server name"
  key_id      = var.parm_key
}
resource "aws_ssm_parameter" "db_port" {
  name        = "/${var.app_name}/pipelines/db/port"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_port
  description = "The ${var.app_name} ${var.environment} DB port"
  key_id      = var.parm_key

}
resource "aws_ssm_parameter" "secret_id" {
  name        = "/${var.app_name}/${var.environment}/db/secret_id"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_master_user_secret[0].secret_arn
  description = "The ${var.app_name} ${var.environment} db login secret id"
  key_id      = var.parm_key
}

resource "aws_ssm_parameter" "vpc_id" {
  name        = "/${var.app_name}/${var.environment}/db/vpc_id"
  type        = "SecureString"
  value       = module.vpc.vpc_id
  description = "The VPC the ${var.app_name} ${var.environment} resides in"
  key_id      = var.parm_key
}
