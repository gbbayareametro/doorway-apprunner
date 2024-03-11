variable "stack_prefix" {
  type        = string
  description = "Resource naming prefix - [app (Doorway usually)]-[environment]"
}
variable "name" {
  type        = string
  description = "name of the resource"
  default     = "database"

}
