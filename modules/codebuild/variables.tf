
variable "name" {
  type        = string
  description = "Name of the build"
}
variable "description" {
  type = string

}
variable "buildspec" {
  type    = string
  default = "buildspec.yml"
}
variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "List of environment variable maps to be used in the running of the build"
  default     = []

}


variable "allowed_aws_actions" {
  type        = list(string)
  description = "The AWS actions this codebuild instance is allowed to perform"
}
variable "build_timeout" {
  type        = number
  description = "Time in minutes"
  default     = 5

}
variable "log_bucket" {
  type        = string
  description = "name of the log bucket being passed by the pipeline"

}

variable "build_image_url" {
  type    = string
  default = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"

}
variable "environment_type" {
  type    = string
  default = "LINUX_CONTAINER"

}
variable "compute_type" {
  type    = string
  default = "BUILD_GENERAL1_SMALL"


}
variable "secondary_sources" {
  type    = list(map(string))
  default = []

}
