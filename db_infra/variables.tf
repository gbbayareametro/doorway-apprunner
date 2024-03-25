variable "master_username" {
  type    = string
  default = "doorway"
}
variable "app_name" {
  type    = string
  default = "dw"

}
variable "environment" {
  type = string

}
variable "parm_key" {
  type        = string
  description = "The encryption key for the parameter store"

}
