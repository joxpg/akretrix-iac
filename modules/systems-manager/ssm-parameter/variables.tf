variable "name" {
  type        = string
  description = "Name of the SSM parameter (e.g. /akretrix/acm/wildcard_certificate_arn)"
}

variable "type" {
  type        = string
  description = "Type of the parameter (String, StringList, SecureString)"
  default     = "String"
}

variable "value" {
  type        = string
  description = "Value of the SSM parameter"
}

variable "description" {
  type        = string
  description = "Description of the parameter"
  default     = null
}

variable "overwrite" {
  type        = bool
  description = "Whether to overwrite existing parameter if it exists"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the SSM parameter resource"
  default     = {}
}
