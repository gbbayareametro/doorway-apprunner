variable "aws_region" {
    type = string
    default = "us-west-2"
  
}
variable "default_tags" {
    type = map(string)
    default = {"Name": "Doorway",}
  
}
variable "service_name" {
    type = string
    default = "apprunner"
  
}
