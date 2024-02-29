terraform {
  required_version = ">= 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
  backend "s3" {
    bucket         = "dw-dev-bootstrap-s3-artifacts"
    key            = "terraform/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    kms_key_id = "arn:aws:kms:us-west-2:364076391763:key/e8bcda76-980f-42e5-97e5-12aae43c4fd9"
  }
}