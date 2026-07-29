variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
}

variable "role_arn" {
  description = "Amazon Resource Name (ARN) of the function's execution role"
  type        = string
}

variable "handler" {
  description = "Function entrypoint in your code"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Identifier of the function's runtime"
  type        = string
  default     = "nodejs20.x"
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Amount of time your Lambda Function has to run in seconds"
  type        = number
  default     = 15
}

variable "filename" {
  description = "Path to the function's deployment package within the local filesystem"
  type        = string
  default     = null
}

variable "source_code_hash" {
  description = "Base64-encoded SHA256 hash of the package file"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Map of environment variables that are accessible from the function code during execution"
  type        = map(string)
  default     = {}
}

variable "api_gateway_id" {
  description = "ID of the API Gateway HTTP API to integrate with (optional)"
  type        = string
  default     = null
}

variable "api_gateway_execution_arn" {
  description = "Execution ARN of the API Gateway to grant invocation permissions (optional)"
  type        = string
  default     = null
}

variable "route_key" {
  description = "Route key for API Gateway integration (optional, e.g. '$default' or 'GET /hello')"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
