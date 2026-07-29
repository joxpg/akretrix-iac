variable "name" {
  description = "The name of the IAM role"
  type        = string
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = null
}

variable "assume_role_policy" {
  description = "The policy that grants an entity permission to assume the role (JSON formatted string)"
  type        = string
}

variable "managed_policy_arns" {
  description = "Set of IAM managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "policy_statements" {
  description = "List of IAM policy statement maps to attach as an inline policy"
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
