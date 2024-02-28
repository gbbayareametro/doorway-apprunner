variable "app_name" {
  type = string
  default = "dw"

}
variable "environment" {
  type = string
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
