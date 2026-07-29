variable "environment" {
  type        = string
  description = "Target deployment environment (e.g. pdn, qa, dev)"
}

variable "parameters" {
  type = map(object({
    name        = string
    type        = optional(string, "String")
    value       = string
    description = optional(string)
    overwrite   = optional(bool, true)
  }))
  description = "Map of SSM parameters to create"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default     = {}
}
