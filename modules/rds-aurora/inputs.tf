variable "vpc_id" {
    type = string
    description = "The VPC ID the database will reside in."
  
}
variable "database_subnet_group_name" {
    type = string
    description = "The name of the database subnet group."
  
}
variable "database_subnets_cidr_blocks" {
    type = list(string)
    description = "The database CIDR blocks"
  
}

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
    default = "doorway-dev"
}
variable "environment" {
    type = string
    default = "dev"
  
}
