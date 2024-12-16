output "ApiId" {
  description = "API ID (prefix of API URL)"
  value       = aws_api_gateway_rest_api.dataflow.id
}

output "ApiName" {
  description = "API Friendly name"
  value       = aws_api_gateway_rest_api.dataflow.name
}

output "RootUrl" {
  description = "Root URL of the API gateway"
  value       = "https://${aws_api_gateway_rest_api.dataflow.id}.execute-api.${var.AWSRegion}.amazonaws.com/${local.should_not_create_env_resources ? "Prod" : var.env}"
}