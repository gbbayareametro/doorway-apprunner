variable "stack_prefix" {
  type        = string
  description = "Resource naming prefix - [app (Doorway usually)]-[environment]"
  default     = "dw-dev-db"
}
