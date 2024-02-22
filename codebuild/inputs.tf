variable "app_name" {
    type = string
    default = "doorway"
  
}
variable "environment" {
    type = string
    default = "dev"
}
variable "stack" {
    type = string
  
}
variable "project_use" {
    type = string
    description = "A helpful listing of what the bucket is being used for. "
  
}
variable "description" {
    type = string
  
}
variable "environment_variables" {
    type = list(object({
        name = string
        value = string
    }))
    description = "List of environment variable maps to be used in the running of the build"
    default = []
  
}
variable "output_artifact_name" {
    type = string
    description = "list of the output artifacts being built"
  
}
variable "default_tags" {
    type = map(string)
    default = {"Name": "Doorway",}
  
}
