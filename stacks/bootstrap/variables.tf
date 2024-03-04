variable "pipeline_environment" {
  type    = string
  default = "prod"

}
variable "app_name" {
  type    = string
  default = "dw"
}
variable "infra_pipeline_envs" {
  type        = list(string)
  default     = ["prod"]
  description = "List of environments that will be created by the codepipeline this creates - defaults to only oneoff"
}
