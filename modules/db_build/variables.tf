variable "log_bucket" {
  type        = string
  description = "The bucket to write logs to"
}
variable "log_bucket_arn" {
  type = string
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
variable "secondary_sources" {
  type    = list(map(string))
  default = []
}
variable "buildspec" {
  type = string
}
variable "ssm_paraneter_encryption_key_id" {
  type = string

}
variable "database_name" {
  type    = string
  default = "doorway"
}



