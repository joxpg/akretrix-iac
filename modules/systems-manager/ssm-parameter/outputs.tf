output "arn" {
  description = "ARN of the SSM parameter"
  value       = aws_ssm_parameter.this.arn
}

output "name" {
  description = "Name of the SSM parameter"
  value       = aws_ssm_parameter.this.name
}

output "version" {
  description = "Version of the SSM parameter"
  value       = aws_ssm_parameter.this.version
}
