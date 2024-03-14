variable "name" {
  type = string

}
variable "infra_source_repo" {
  type        = string
  default     = "gbbayareametro/doorway-apprunner"
  description = "the name of the Github repository the infrastructure source code is located in"

}
variable "infra_source_branch" {
  type        = string
  default     = "main"
  description = "the name of the branch"
}
variable "app_name" {
  type    = string
  default = "dw"

}
variable "build_envs" {
  type    = list(string)
  default = ["oneoff"]

}
