
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
  default = "env_build/buildspec.yaml"
}
