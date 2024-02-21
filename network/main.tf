terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = "~> 5"
    }
  }
}
provider "aws" {
  region = var.aws_region
  default_tags { tags = var.default_tags }
}
################################################################################
# VPC Module
################################################################################
locals {
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "${var.app_name}-${var.environment}-vpc"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}
data "aws_availability_zones" "available" {
  
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"
  name = local.vpc_name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  database_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]
  database_subnet_names    = [for k, v in local.azs : "${var.app_name}-${var.environment}-db-${k}" ]
 
}