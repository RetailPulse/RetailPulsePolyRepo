output "api_base_url_2" {
  description = "Base URL for API Gateway"
  value       = "${aws_apigatewayv2_api.multi_service_api.api_endpoint}/prod"
}
