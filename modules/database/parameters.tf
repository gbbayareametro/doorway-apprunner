

resource "aws_ssm_parameter" "db_host" {
  name        = "/${var.app_name}/pipelines/${var.pipeline_name}/${var.environment}/db/host"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_endpoint
  description = "The bucket for the tf state files for this pipeline"
  key_id      = var.ssm_encryption_key
}
resource "aws_ssm_parameter" "db_port" {
  name        = "/${var.app_name}/pipelines/${var.pipeline_name}/${var.environment}/db/port"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_port
  description = "The bucket for the tf state files for this pipeline"
  key_id      = var.ssm_encryption_key
}
resource "aws_ssm_parameter" "secret_id" {
  name        = "/${var.app_name}/pipelines/${var.pipeline_name}/${var.environment}/db/secret_id"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_master_user_secret.0.secret_arn
  description = "The bucket for the tf state files for this pipeline"
  key_id      = var.ssm_encryption_key
}
