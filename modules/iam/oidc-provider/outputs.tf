output "arn" {
  description = "The ARN assigned by AWS for this provider"
  value       = var.create_oidc_provider ? aws_iam_openid_connect_provider.this[0].arn : null
}
