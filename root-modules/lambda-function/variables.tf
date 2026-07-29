variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, prod)"
  type        = string
}

variable "handler" {
  description = "Lambda handler function entry point"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda runtime engine"
  type        = string
  default     = "nodejs20.x"
}

variable "memory_size" {
  description = "Amount of memory in MB for the Lambda function"
  type        = number
  default     = 256
}

variable "timeout" {
  description = "Timeout in seconds for the Lambda function"
  type        = number
  default     = 10
}

variable "filename" {
  description = "Path to deployment package zip file"
  type        = string
  default     = null
}

variable "source_code_hash" {
  description = "Base64 encoded SHA256 hash of the package"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Map of environment variables to pass to the function"
  type        = map(string)
  default     = {}
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 30
}

variable "api_gateway_id" {
  description = "Optional ID of API Gateway to attach this Lambda to"
  type        = string
  default     = null
}

variable "api_gateway_execution_arn" {
  description = "Optional API Gateway execution ARN for invoke permission"
  type        = string
  default     = null
}

variable "route_key" {
  description = "Optional API Gateway route key (e.g., 'GET /endpoints')"
  type        = string
  default     = null
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
