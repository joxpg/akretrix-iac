variable "create_oidc_provider" {
  description = "Whether to create the OpenID Connect provider"
  type        = bool
  default     = true
}

variable "url" {
  description = "The URL of the identity provider"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "client_id_list" {
  description = "A list of client IDs (audiences)"
  type        = list(string)
  default     = ["sts.amazonaws.com"]
}

variable "thumbprint_list" {
  description = "A list of server certificate thumbprints for the OpenID Connect identity provider's server certificates"
  type        = list(string)
  default     = ["227203b5317f3818cab5b5ce596132bf36748c0e", "1b511abead59c6ce207077c0bf0e0043b1382612", "1c58a21d2c5758ad36ec14f96f32e68d2980edd7", "6938fd4d98bab03faadb97b34396831e3780aea1"]
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
