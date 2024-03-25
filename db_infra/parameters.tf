
# trunk-ignore(checkov/CKV_TF_1): global terraform registry doesn't use commit hash versioning
module "kms_parameter_store" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.2.0"
}
resource "aws_ssm_parameter" "db_host" {
  name        = "/${var.app_name}/${var.environment}/db/host"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_endpoint
  description = "the ${var.app_name} ${var.environment} DB server name"
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "db_port" {
  name        = "/${var.app_name}/pipelines/db/port"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_port
  description = "The ${var.app_name} ${var.environment} DB port"
  key_id      = module.kms_parameter_store.key_id

}
resource "aws_ssm_parameter" "secret_id" {
  name        = "/${var.app_name}/${var.environment}/db/secret_id"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_master_user_secret[0].secret_arn
  description = "The ${var.app_name} ${var.environment} db login secret id"
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "parameter_encryptor_id" {
  name        = "/${var.app_name}/${var.environment}/ssm/parameter_encryptor_id"
  type        = "SecureString"
  value       = module.kms_parameter_store.key_id
  description = "Used to encrypt SSM parameters for ${var.app_name} ${var.environment}"
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "vpc_id" {
  name        = "/${var.app_name}/${var.environment}/db/vpc_id"
  type        = "SecureString"
  value       = module.vpc.vpc_id
  description = "The VPC the ${var.app_name} ${var.environment} resides in"
  key_id      = module.kms_parameter_store.key_id
}
