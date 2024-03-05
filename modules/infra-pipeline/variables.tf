variable "pipeline_environment" {
  type        = string
  description = "The pipeline environment variable allows you to build out test pipelines when doing major infrastructure work so as not to interrupt the primary pipeline"

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
variable "doorway_source_repo" {
  type        = string
  default     = "metrotranscom/doorway"
  description = "the name of the Github repository the Doorway source code is located in"

}
variable "doorway_source_branch" {
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
