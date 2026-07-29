output "parameter_arns" {
  description = "Map of parameter ARNs"
  value       = { for k, v in module.ssm_parameter : k => v.arn }
}

output "parameter_names" {
  description = "Map of parameter names"
  value       = { for k, v in module.ssm_parameter : k => v.name }
}
