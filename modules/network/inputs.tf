variable "aws_region" {
    type = string
    default = "us-west-2"
  
}
variable "default_tags" {
    type = map(string)
    default = {"Name": "Doorway",}
  
}

variable "app_name" {
    type = string
    default = "doorway"
  
}
variable "environment" {
    type = string
    default = "dev"
  
}