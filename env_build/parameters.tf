
# trunk-ignore(checkov/CKV_TF_1): global terraform registry doesn't use commit hash versioning
module "kms_parameter_store" {
  source  = "terraform-aws-modules/kms/aws"
  version = "2.2.0"
}

resource "aws_ssm_parameter" "tf_state_key" {
  name        = "/${var.app_name}/env_build/tf_state_key"
  type        = "SecureString"
  value       = module.tf_state_bucket.encryption_key_arn
  description = "the encryption key ID for the tf state bucket "
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "tf_state_bucket" {
  name        = "/${var.app_name}/env_build/tf_state_bucket"
  type        = "SecureString"
  value       = module.tf_state_bucket.bucket
  description = "the tf state bucket "
  key_id      = module.kms_parameter_store.key_id
}
resource "aws_ssm_parameter" "parameter_encryptor_id" {
  name        = "/${var.app_name}/env_build/parameter_encryptor_id"
  type        = "SecureString"
  value       = module.kms_parameter_store.key_id
  description = "encryption key id for the parm store "
  key_id      = module.kms_parameter_store.key_id
}
