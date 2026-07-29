output "api_id" {
  description = "The API identifier"
  value       = aws_apigatewayv2_api.this.id
}

output "api_endpoint" {
  description = "The URI of the API"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn when allowing API Gateway to invoke a Lambda function"
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "stage_id" {
  description = "The stage identifier"
  value       = aws_apigatewayv2_stage.this.id
}
