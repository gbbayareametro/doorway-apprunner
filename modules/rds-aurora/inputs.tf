variable "stack_prefix" {
    type = string
    description = "Resource naming prefix - [app (Doorway usually)]-[environment]"
    default = "dw-dev"
}
variable "resource_use" {
    type = string
    description = "Part of the resource naming convention s/b [app]-[environment]-[stack]-[resource (i.e S3)]-[resource_use i.e logs]"
    default = "db"
}