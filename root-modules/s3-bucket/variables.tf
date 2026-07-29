variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Whether to allow force destroying all objects on bucket deletion."
}

variable "block_public_access" {
  type        = bool
  default     = true
  description = "Whether to block all public access to the bucket."
}

variable "enable_encryption" {
  type        = bool
  default     = true
  description = "Whether to enable default server-side encryption."
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "Encryption algorithm to use (AES256 or aws:kms)."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the S3 bucket."
}
