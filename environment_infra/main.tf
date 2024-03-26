locals {
  #The name variables are the infrastructure names NOT actual public urls.
  db_name             = "${var.app_name}-${var.environment}"
  api_name            = "${var.app_name}-${var.environment}-api"
  public_portal_name  = "${var.app_name}-${var.environment}-public"
  private_portal_name = "${var.app_name}-${var.environment}-private"
  cors_origins        = "${var.public_portal_url},${var.partners_portal_url}"

}



