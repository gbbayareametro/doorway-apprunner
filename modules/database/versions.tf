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
provider "postgresql" {
  host     = module.aurora_postgresql_v2.cluster_endpoint
  port     = 5432
  username = module.aurora_postgresql_v2.cluster_master_username
  password = module.aurora_postgresql_v2.cluster_master_password
}
