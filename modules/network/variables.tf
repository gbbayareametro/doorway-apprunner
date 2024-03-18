
variable "name" {
  type        = string
  description = "Resource naming prefix - [app (Doorway usually)]-[environment]"
}
variable "app_name" {
  type    = string
  default = "dw"

}
variable "pipeline_name" {
  type = string
}
variable "environment" {
  type = string

}
variable "cidr" {
  type    = string
  default = "10.0.0.0/16"

}
variable "ssm_encryption_key" {
  type = string

}