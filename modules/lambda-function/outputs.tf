output "function_arn" {
  description = "Amazon Resource Name (ARN) identifying your Lambda Function"
  value       = aws_lambda_function.this.arn
}

output "function_name" {
  description = "Unique name identifying your Lambda Function"
  value       = aws_lambda_function.this.function_name
}

output "invoke_arn" {
  description = "ARN to be used for invoking Lambda Function from API Gateway"
  value       = aws_lambda_function.this.invoke_arn
}
