terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}
provider "aws" {
  region = var.aws_region
  default_tags { tags = var.default_tags }
}
resource "aws_apprunner_service" "service" {
  service_name = var.service_name
  source_configuration {
    image_repository {
      image_configuration {
        port = "80"
      }
      image_identifier      = "public.ecr.aws/nginx/nginx:stable-perl"
      image_repository_type = "ECR_PUBLIC"
    }
    auto_deployments_enabled = false
  }
}
resource "aws_apprunner_custom_domain_association" "domain" {
  domain_name          = "apprunner.housingbayarea.mtc.ca.gov"
  service_arn          = aws_apprunner_service.service.arn
  enable_www_subdomain = false
}
data "aws_route53_zone" "primary" {
  name         = "housingbayarea.mtc.ca.gov"
  private_zone = false
}
resource "aws_route53_record" "service_url" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = aws_apprunner_service.service.service_name
  type    = "CNAME"
  ttl     = 300
  records = [aws_apprunner_service.service.service_url]
}
resource "aws_route53_record" "cname" {
  for_each = {
    for entry in aws_apprunner_custom_domain_association.domain.certificate_validation_records : entry.name => {
      name   = entry.name
      record = entry.value
      type   = entry.type
    }
  }
  name    = each.value.name
  type    = "CNAME"
  ttl     = 300
  zone_id = data.aws_route53_zone.primary.zone_id
  records = [each.value.record]
}
