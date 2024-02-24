variable "app_name" {
  type = string
  default = "doorway"

}
variable "environment" {
  type = string
  default = "dev"
}

variable "site_domain" {
  type    = string
  default = "dev.housingbayarea.mtc.ca.gov"

}
variable "route53_hosted_zone_name" {
  type    = string
  default = "housingbayarea.mtc.ca.gov"
}
variable "default_tags" {
    type = map(string)
    default = {"Name": "Doorway",}
  
}
variable "default_aws_region" {
    type = map(string)
    default = {"Name": "Doorway",}
  
}
