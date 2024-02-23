variable "default_tags" {
    type = map(string)
    default = {"Name": "Doorway",}
  
}
variable "app_name" {
    type = string
    default = "doorway-dev"
}
variable "environment" {
    type = string
    default = "dev"
  
}