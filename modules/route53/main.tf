terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "~> 4.64"
    }
  }
}
provider "aws" {
  region = var.aws_region
  default_tags { tags = var.default_tags }
}
