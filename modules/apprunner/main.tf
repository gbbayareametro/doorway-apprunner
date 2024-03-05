
resource "aws_apprunner_connection" "github" {
  connection_name = "${var.stack_prefix}-gh"
  provider_type   = "GITHUB"

  tags = var.default_tags
}
resource "aws_apprunner_service" "service" {
  service_name = "${var.stack_prefix}-${var.resource_use}"
  source_configuration {
    authentication_configuration {
      connection_arn = aws_apprunner_connection.example.arn
    }
    auto_deployments_enabled = var.autodeploy
    code_repository {
      code_configuration {
        code_configuration_values {
          build_command = var.build_command
          port          = var.http_port
          runtime       = var.runtime
          start_command = var.start_command
        }
        configuration_source = "API"
      }
      repository_url   = var.github_repo
      source_directory = var.source_directory
      source_code_version {
        type  = "BRANCH"
        value = "main"
      }
    }
  }
  tags = var.default_tags
}
resource "aws_apprunner_custom_domain_association" "domain" {
  domain_name          = var.domain_name
  service_arn          = aws_apprunner_service.service.arn
  enable_www_subdomain = false
}
data "aws_route53_zone" "primary" {
  name         = "housingbayarea.mtc.ca.gov"
  private_zone = false
}
resource "aws_route53_record" "service_url" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = aws_apprunner_service.service.service_name
  type    = "CNAME"
  ttl     = 300
  records = [aws_apprunner_service.service.service_url]
}
resource "aws_route53_record" "cname" {
  for_each = {
    for entry in aws_apprunner_custom_domain_association.domain.certificate_validation_records : entry.name => {
      name   = entry.name
      record = entry.value
      type   = entry.type
    }
  }
  name    = each.value.name
  type    = "CNAME"
  ttl     = 300
  zone_id = data.aws_route53_zone.primary.zone_id
  records = [each.value.record]
}
