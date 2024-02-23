output "name" {
    value = aws_apprunner_service.service.service_name
}
output "url" {
    value = aws_apprunner_service.service.service_url
}
output "arn" {
    value = aws_apprunner_service.service.arn
}