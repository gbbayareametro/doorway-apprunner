data "aws_region" "current" {}
resource "aws_apprunner_connection" "github" {
  connection_name = "${var.app_name}-${var.environment}-gh"
  provider_type   = "GITHUB"

}
resource "aws_apprunner_service" "service" {
  service_name = local.api_name
  instance_configuration {
    instance_role_arn = aws_iam_role.apprunner_role
  }
  source_configuration {
    authentication_configuration {
      connection_arn = aws_apprunner_connection.github.arn
    }
    auto_deployments_enabled = var.autodeploy_apps
    code_repository {
      code_configuration {
        code_configuration_values {
          build_command = "yarn install&&yarn build"
          port          = var.api_port
          runtime       = var.runtime
          start_command = "yarn db:migration&&yarn start"
          runtime_environment_variables = {
            APP_SECRET : "<dummy-value-that-is-at-least-16-character-long>",
            ASSET_FILE_SERVICE : "s3",
            ASSET_FS_CONFIG_s3_BUCKET : module.uploads_bucket.bucket,
            ASSET_FS_CONFIG_s3_REGION : data.aws_region.current.name,
            ASSET_FS_CONFIG_s3_URL_FORMAT : "public",
            ASSET_UPLOAD_MAX_SIZE : 5,
            CLOUDINARY_KEY : "<dummy-value>",
            CLOUDINARY_SECRET : "<dummy-value>",
            CORS_ORIGINS : local.cors_origins,
            LISTINGS_QUERY : "/listings",
            PARTNERS_BASE_URL : var.partners_portal_url,
            PARTNERS_PORTAL_URL : var.partners_portal_url,
            PORT : var.api_port
            SHOW_DUPLICATES : "FALSE"
            NO_COLOR : true
            SHOW_LM_LINKS : "TRUE"
          }
          runtime_environment_secrets = {
            PGUSER : "${aws_ssm_parameter.secret_id.value}:username"
            PGPASSWORD : "${aws_ssm_parameter.secret_id.value}:password"
            PGHOST : aws_ssm_parameter.db_host.value
            PGDATABASE : aws_ssm_parameter.db_name.value
            EMAIL_API_KEY : data.aws_ssm_parameter.sendgrid.value

          }
        }
        configuration_source = "API"
      }
      repository_url   = var.github_repo
      source_directory = "backend/core"
      source_code_version {
        type  = "BRANCH"
        value = var.branch
      }
    }
  }
}
module "uploads_bucket" {
  source = "../modules/s3_prefix"
  name   = "${var.app_name}-${var.environment}-uploads"

}
