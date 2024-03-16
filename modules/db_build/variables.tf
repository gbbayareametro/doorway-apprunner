variable "log_bucket" {
  type        = string
  description = "The bucket to write logs to"
}
variable "name" {
  type = string
}
variable "database_server_name" {
  type = string
}

variable "artifact_encryption_key_arn" {
  type = string
}

variable "buildspec" {
  type = string
}
variable "ssm_paraneter_encryption_key_id" {
  type = string

}
variable "tf_state_bucket" {
  type = string

}


