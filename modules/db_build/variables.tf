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
variable "resource_name" {
  type    = string
  default = "db-build"

}
variable "database_server_resource_name" {
  type    = string
  default = "db"

}

variable "artifact_encryption_key_arn" {
  type = string
}
variable "secondary_sources" {
  type    = list(map(string))
  default = [{ source_id = "doorway_source", source_location = "https://github.com/metrotranscom/doorway.git" }]
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



