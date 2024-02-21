terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = "~> 4.64"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags { tags = var.default_tags }
}
data "aws_route53_zone" "primary" {
  name = "housingbayarea.mtc.ca.gov"
  private_zone = false
}
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.apprunner_service.name
  type    = "CNAME"
  ttl     = 300
  records = [var.apprunner_service.url]
}