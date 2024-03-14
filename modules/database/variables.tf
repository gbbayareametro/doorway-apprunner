variable "name" {
  type        = string
  description = "The name of the resource that will be used in AWS"
}
variable "vpc_id" {
  type = string
}

variable "database_subnet_group" {
  type        = string
  description = "The name of the database subnet group"

}


variable "master_username" {
  type        = string
  default     = "root"
  description = "pg admin"

}
variable "app_user" {
  type        = string
  default     = "doorway"
  description = "Doorway app user"


}
variable "database_name" {
  type        = string
  default     = "doorway"
  description = "The name of the database on the database server"
}
