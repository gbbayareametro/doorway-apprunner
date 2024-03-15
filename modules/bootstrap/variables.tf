variable "pipeline_name" {
  type    = string
  default = "prod-pipeline"

}
variable "app_name" {
  type    = string
  default = "dw"
}
variable "github_repo" {
  type    = string
  default = "https://github.com/gbbayareametro/doorway-apprunner.git"
}
variable "buildspec" {
  type    = string
  default = "stacks/prod-pipeline/buildspec.yaml"
}
