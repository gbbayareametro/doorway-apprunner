output "app_name" {
  value = var.app_name
}
output "environment" {
  value = var.environment
}
output "environment_prefix" {
  value       = "${var.app_name}-${var.environment}"
  description = "Prefix used in infrastructure naming. Pattern is app-environment. Stacks will add the stack name. "
}
output "route53_hosted_zone_name" {
  value = var.route53_hosted_zone_name
}
output "default_aws_region" {
  value = var.default_aws_region

}
output "default_tags" {
  value = var.default_tags
}
