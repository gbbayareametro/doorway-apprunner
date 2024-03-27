locals {
  #The name variables are the infrastructure names NOT actual public urls.
  db_name             = "${var.app_name}-${var.environment}"
  api_name            = "${var.app_name}-${var.environment}-api"
  public_portal_name  = "${var.app_name}-${var.environment}-public"
  private_portal_name = "${var.app_name}-${var.environment}-private"
  ecs_cluster_name    = "${var.app_name}-${var.environment}-ecs"
  cors_origins        = "${var.public_portal_url},${var.partners_portal_url}"
  azs                 = slice(data.aws_availability_zones.available.names, 0, 3)
  cidr                = "10.0.0.0/16"
}

data "aws_availability_zones" "available" {}
