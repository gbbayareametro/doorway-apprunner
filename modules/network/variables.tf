
variable "name" {
  type        = string
  description = "Resource naming prefix - [app (Doorway usually)]-[environment]"
}
variable "cidr" {
  type    = string
  default = "10.0.0.0/16"

}
