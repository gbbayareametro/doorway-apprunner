variable "stack_prefix" {
    type = string
    description = "Resource naming prefix - [app (Doorway usually)]-[environment]"
}
variable "resource_use" {
    type = string
    description = "Part of the resource naming convention s/b [app]-[environment]-[stack]-[resource (i.e S3)]-[resource_use i.e logs]"
}
variable "description" {
    type = string
  
}
variable "buildspec" {
    type = string
    default = "buildspec.yml"
}

variable "environment_variables" {
    type = list(object({
        name = string
        value = string
    }))
    description = "List of environment variable maps to be used in the running of the build"
    default = []
  
}
variable "artifact_encryption_key_arn" {
    type = string
    description = "Used to encrypt any output artifacts"
  
}
variable "default_tags" {
    type = map(string)
    default = {"Name": "Doorway",}
  
}

variable "allowed_aws_actions" {
    type = list(string)
    description = "The AWS actions this codebuild instance is allowed to perform"
}
variable "build_timeout" {
    type = number
    description = "Time in minutes"
    default = 5
  
}
variable "log_bucket" {
    type = string
    description = "name of the log bucket being passed by the pipeline"
  
}