output "function_name" {
  description = "Name of the deployed Lambda function"
  value       = module.lambda.function_name
}

output "function_arn" {
  description = "ARN of the deployed Lambda function"
  value       = module.lambda.function_arn
}

output "invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = module.lambda.invoke_arn
}

output "role_arn" {
  description = "ARN of the IAM execution role"
  value       = module.lambda_role.role_arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = module.lambda_log_group.log_group_name
}
