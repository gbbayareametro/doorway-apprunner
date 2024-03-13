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
  default = "db-migrator"
}
variable "database_name" {
  type    = string
  default = "database"

}
variable "db_server_id" {
  type = string
}
variable "artifact_encryption_key_arn" {
  type = string
}
variable "secondary_sources" {
  type    = list(map(string))
  default = [{ source_id = "doorway_source", source_location = "https://github.com/metrotranscom/doorway.git" }]
}
