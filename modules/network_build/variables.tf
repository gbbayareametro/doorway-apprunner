variable "name" {
  type = string
}
variable "pipeline_name" {
  type = string
}
variable "buildspec" {
  type    = string
  default = "modules/network_build/buildspec.yaml"
}
variable "app_name" {
  type    = string
  default = "dw"
}
variable "log_bucket" {
  type = string
}
variable "environment" {
  type = string
}
