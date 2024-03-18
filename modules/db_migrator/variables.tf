variable "app_name" {
  type    = string
  default = "dw"
}
variable "environment" {
  type = string
}
variable "pipeline_name" {
  type = string
}
variable "name" {
  type = string

}
variable "log_bucket" {
  type        = string
  description = "The bucket to write logs to"
}
variable "secondary_sources" {
  type    = list(map(string))
  default = [{ source_id = "doorway_source", source_location = "https://github.com/metrotranscom/doorway.git" }]
}
variable "vpcs" {
  type = list(object({
    vpc_id             = string,
    subnets            = list(string),
    security_group_ids = list(string)
  }))
}
