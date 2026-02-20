output "strix_gateway_url" {
  description = "API Gateway webhook URL"
  value       = aws_apigatewayv2_api.strix_api.api_endpoint
}
