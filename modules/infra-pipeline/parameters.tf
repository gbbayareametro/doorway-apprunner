# trunk-ignore(checkov/CKV_TF_1): global terraform registry doesn't use commit hash versioning
module "kms_parameter_store" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.2.0"
}
resource "aws_ssm_parameter" "tf_state_bucket_parm" {
  name        = "/${var.app_name}/pipelines/${var.name}/tf_state_bucket"
  type        = "SecureString"
  value       = module.tf_state_bucket.bucket
  description = "The bucket for the tf state files for this pipeline"
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "tf_state_encryption_key_arn" {
  name        = "/${var.app_name}/pipelines/${var.name}/tf_state_bucket_encryption_key"
  type        = "SecureString"
  value       = module.tf_state_bucket.encryption_key_arn
  description = "The the encryption key for the bucket for the tf state files for this pipeline"
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "log_bucket_parm" {
  name        = "/${var.app_name}/pipelines/${var.name}/log_bucket"
  type        = "SecureString"
  value       = module.log_bucket.bucket
  description = "The bucket for the tf state files for this pipeline"
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "log_bucket_encryption_key_arn" {
  name        = "/${var.app_name}/pipelines/${var.name}/log_bucket_encryption_key"
  type        = "SecureString"
  value       = module.log_bucket.encryption_key_arn
  description = "The the encryption key for the bucket for the tf state files for this pipeline"
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "ssm_encryption_key" {
  name        = "/${var.app_name}/pipelines/${var.name}/ssm_encryption_key"
  type        = "SecureString"
  value       = module.kms_parameter_store.key_id
  description = "The the encryption key for the bucket for the tf state files for this pipeline"
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "vpc_name" {
  for_each    = toset(var.build_envs)
  name        = "/${var.app_name}/pipelines/${var.name}/${each.key}/vpc_name"
  type        = "SecureString"
  value       = "${var.app_name}-${each.key}"
  description = "the VPC id for each environment in the pipeline"
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "vpc_id" {
  for_each    = toset(var.build_envs)
  name        = "/${var.app_name}/pipelines/${var.name}/${each.key}/vpc_id"
  type        = "SecureString"
  value       = module.vpc.vpc_id
  description = "the VPC id for each environment in the pipeline"
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "database_server_name" {
  for_each    = toset(var.build_envs)
  name        = "/${var.app_name}/pipelines/${var.name}/${each.key}/db/server_name"
  type        = "SecureString"
  value       = "${var.app_name}-db-${each.key}"
  description = "the VPC id for each environment in the pipeline"
  key_id      = module.kms_parameter_store.key_id
}


