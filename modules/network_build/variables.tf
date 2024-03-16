variable "name" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "log_bucket" {
  type        = string
  description = "The bucket to write logs to"
}
variable "artifact_bucket" {
  type = string

}
variable "artifact_encryption_key_arn" {
  type        = string
  description = "Encryption key for build artifacts"

}
variable "buildspec" {
  type    = string
  default = "modules/network_build/buildspec.yaml"
}




