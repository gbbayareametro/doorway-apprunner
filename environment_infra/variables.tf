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
variable "autodeploy_apps" {
  type    = bool
  default = false

}
variable "api_port" {
  type    = number
  default = 3100

}
variable "runtime" {
  type    = string
  default = "NODEJS_18"
}
variable "github_repo" {
  type    = string
  default = "https://github.com/gbbayareametro/doorway-apprunner.git"

}
variable "branch" {
  type    = string
  default = "main"

}
variable "public_portal_url" {
  type    = string
  default = "http://dev2.housingbayarea.mtc.ca.gov"

}
variable "partners_portal_url" {
  type    = string
  default = "http://partners.dev2.housingbayarea.mtc.ca.gov"

}
variable "database_name" {
  type    = string
  default = "doorway"

}
