variable "artifact_bucket_name" {
  type        = string
  description = "S3 bucket name for storing Lambda deployment build artifacts."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
