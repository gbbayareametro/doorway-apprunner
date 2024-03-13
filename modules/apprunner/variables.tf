variable "stack_prefix" {
  type        = string
  description = "Infrastructure prefix for everything in an environment. usually dw-[env]-[stack]"
}
variable "default_tags" {
  type    = map(string)
  default = { "Name" : "Doorway", }

}
variable "resource_name" {
  type        = string
  description = "One-word (usually) description of why this infra is being created. In the apprunner case its usually 'public','partner' or 'api'."
  default     = "apprunner"

}
variable "github_repo" {
  type = string

}
variable "autodeploy" {
  type    = bool
  default = false

}
variable "source_directory" {
  type        = string
  description = "The location of the app in the repo. "

}
variable "build_command" {
  type    = string
  default = "yarn install&&yarn build"

}
variable "start_command" {
  type    = string
  default = "yarn start"
}

variable "runtime" {
  type    = string
  default = "NODEJS_18"

}
variable "http_port" {
  type    = number
  default = 3000

}
variable "domain_name" {
  type    = string
  default = "changethis.housingbayarea.mtc.ca.gov"

}
