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


resource "aws_apprunner_service" "service" {
  service_name = var.service_name

  source_configuration {
    image_repository {
      image_configuration {
        port = "8000"
      }
      image_identifier      = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type = "ECR_PUBLIC"
    }
    auto_deployments_enabled = false
  }
}
resource "aws_apprunner_custom_domain_association" "domain" {
  domain_name = "apprunner.housingbayarea.mtc.ca.gov"
  service_arn = aws_apprunner_service.service.arn
}
