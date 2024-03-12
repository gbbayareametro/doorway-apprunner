variable "stack_prefix" {
  type        = string
  description = "Resource naming prefix - [app (Doorway usually)]-[environment]"
}
variable "name" {
  type        = string
  description = "name of the resource"
  default     = "database"
}
variable "ssm_paraneter_encryption_key_id" {
  type = string
}

variable "database_name" {
  type    = string
  default = "doorway"

}
