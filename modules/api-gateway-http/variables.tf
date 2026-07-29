variable "name" {
  description = "The name of the API Gateway HTTP API"
  type        = string
}

variable "description" {
  description = "Description of the API Gateway HTTP API"
  type        = string
  default     = null
}

variable "stage_name" {
  description = "The name of the stage"
  type        = string
  default     = "$default"
}

variable "auto_deploy" {
  description = "Whether updates to an API automatically trigger a new deployment"
  type        = bool
  default     = true
}

variable "access_log_destination_arn" {
  description = "ARN of the CloudWatch log group or Kinesis Firehose stream to receive access logs"
  type        = string
  default     = null
}

variable "access_log_format" {
  description = "A single line format of the access logs of data, as specified by selected $context variables"
  type        = string
  default     = null
}

variable "cors_allow_credentials" {
  description = "Whether credentials are included in the CORS request"
  type        = bool
  default     = false
}

variable "cors_allow_headers" {
  description = "Set of allowed HTTP headers"
  type        = list(string)
  default     = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token"]
}

variable "cors_allow_methods" {
  description = "Set of allowed HTTP methods"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allow_origins" {
  description = "Set of allowed origins"
  type        = list(string)
  default     = ["*"]
}

variable "cors_max_age" {
  description = "The number of seconds the browser can cache the preflight response"
  type        = number
  default     = 300
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
