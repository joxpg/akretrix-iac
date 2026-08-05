variable "create_oidc_provider" {
  type        = bool
  default     = false
  description = "Whether to create the GitHub OpenID Connect Provider."
}

variable "existing_oidc_provider_arn" {
  type        = string
  default     = ""
  description = "Existing GitHub OIDC Provider ARN (Required if create_oidc_provider is false and you are creating roles)."
}

variable "roles" {
  type = map(object({
    github_org          = optional(string, "*")
    github_repository   = optional(string, "*")
    github_repositories = optional(list(string), [])
    github_branches     = optional(list(string), ["*"])
    policy_statements   = optional(list(any), [])
    managed_policy_arns = optional(list(string), [])
  }))
  default     = {}
  description = "Map of roles to create. The key is the role name, and the value is the configuration for that role."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources."
}
