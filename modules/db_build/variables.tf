variable "log_bucket" {
  type        = string
  description = "The bucket to write logs to"
}
variable "name" {
  type = string
}
variable "buildspec" {
  type    = string
  default = "modules/db_build/buildspec.yaml"
}
variable "pipeline_name" {
  type        = string
  description = "The name of the build pipeline the job is part of"
}
variable "app_name" {
  type    = string
  default = "dw"
}
variable "environment" {
  type        = string
  description = "The environment the database belongs to"
}
