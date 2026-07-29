output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider."
  value       = local.oidc_provider_arn
}

output "role_arns" {
  description = "Map of created role ARNs, keyed by role name."
  value       = { for k, v in module.github_actions_role : k => v.role_arn }
}

output "role_names" {
  description = "Map of created role names, keyed by role name."
  value       = { for k, v in module.github_actions_role : k => v.role_name }
}
