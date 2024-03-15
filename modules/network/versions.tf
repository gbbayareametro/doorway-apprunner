terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
  backend "s3" {
    bucket     = "oneoff-pipeline-s3-artifacts"
    key        = "terraform/terraform.tfstate"
    region     = "us-west-2"
    encrypt    = true
    kms_key_id = "arn:aws:kms:us-west-2:364076391763:key/e8bcda76-980f-42e5-97e5-12aae43c4fd9"
  }
}
