variable "log_bucket" {
  type        = string
  description = "The bucket to write logs to"
}
variable "log_bucket_arn" {
  type = string
}
variable "stack_prefix" {
  type = string
}
variable "artifact_encryption_key_arn" {
  type = string
}
