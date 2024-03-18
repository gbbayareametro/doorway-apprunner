resource "aws_ssm_parameter" "vpc_name" {
  name        = "/${var.app_name}/pipelines/${var.pipeline_name}/${var.environment}/vpc_id"
  type        = "SecureString"
  value       = module.vpc.vpc_id
  description = "the VPC id for each environment in the pipeline"
  key_id      = var.ssm_encryption_key
}
