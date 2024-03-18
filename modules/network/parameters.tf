resource "aws_ssm_parameter" "vpc_name" {
  name        = "/${var.app_name}/pipelines/${var.pipeline_name}/${var.environment}/vpc_id"
  type        = "SecureString"
  value       = module.vpc.vpc_id
  description = "the VPC id for each environment in the pipeline"
  key_id      = var.ssm_encryption_key
}
#trunk-ignore(checkov/CKV2_AWS_34)
resource "aws_ssm_parameter" "subnets" {
  name        = "/${var.app_name}/pipelines/${var.pipeline_name}/${var.environment}/subnets"
  type        = "StringList"
  value       = module.vpc.private_subnets
  description = "the VPC id for each environment in the pipeline"
  key_id      = var.ssm_encryption_key
}
resource "aws_ssm_parameter" "default_sg" {
  name        = "/${var.app_name}/pipelines/${var.pipeline_name}/${var.environment}/default_sg"
  type        = "SecureString"
  value       = module.vpc.default_security_group_id
  description = "the VPC id for each environment in the pipeline"
  key_id      = var.ssm_encryption_key
}
