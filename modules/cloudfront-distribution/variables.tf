variable "name_prefix" {
  type        = string
  description = "Resource name prefix."
}

variable "origin_domain_name" {
  type        = string
  description = "Regional S3 domain name for the origin."
}

variable "default_root_object" {
  type        = string
  default     = "index.html"
  description = "Default root object for CloudFront."
}

variable "create_oac" {
  type        = bool
  default     = true
  description = "Whether to create CloudFront Origin Access Control."
}

variable "price_class" {
  type        = string
  default     = "PriceClass_100"
  description = "CloudFront price class."
}

variable "custom_domain_names" {
  type        = list(string)
  default     = []
  description = "Custom domain aliases."
}

variable "acm_certificate_arn" {
  type        = string
  default     = ""
  description = "ACM Certificate ARN in us-east-1."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
