variable "stack_prefix" {
  type        = string
  description = "Resource naming prefix - [app (Doorway usually)]-[environment]"
}
variable "resource_name" {
  type        = string
  description = "name of the resource"
  default     = "database"
}
variable "db_master_user" {
  type    = string
  default = "doorway"

}
variable "database_name" {
  type    = string
  default = "doorway"

}
