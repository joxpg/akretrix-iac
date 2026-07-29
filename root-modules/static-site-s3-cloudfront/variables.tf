variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to store static website files."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Whether to force destroy all objects on bucket deletion."
}

variable "price_class" {
  type        = string
  default     = "PriceClass_100"
  description = "CloudFront price class (PriceClass_100, PriceClass_200, PriceClass_All)."
}

variable "custom_domain_names" {
  type        = list(string)
  default     = []
  description = "List of custom CNAME domain aliases for CloudFront."
}

variable "acm_certificate_arn" {
  type        = string
  default     = ""
  description = "ACM SSL Certificate ARN in us-east-1 for custom domains."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
