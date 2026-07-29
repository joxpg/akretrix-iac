output "api_id" {
  description = "The ID of the HTTP API Gateway"
  value       = module.api_gateway.api_id
}

output "api_endpoint" {
  description = "The default URL endpoint of the HTTP API Gateway"
  value       = module.api_gateway.api_endpoint
}

output "execution_arn" {
  description = "The execution ARN of the HTTP API Gateway for Lambda permissions"
  value       = module.api_gateway.execution_arn
}

output "stage_id" {
  description = "The ID of the default API Gateway stage"
  value       = module.api_gateway.stage_id
}
