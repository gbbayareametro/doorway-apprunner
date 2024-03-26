terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.26"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">=1.22.0"

    }
  }
}
provider "aws" {
  region = "us-west-2"

}
provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}
