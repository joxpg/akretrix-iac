terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  api_name = "${var.name_prefix}-${var.environment}-api"
}

# -----------------------------------------------------------------------------
# Invoke Granular CloudWatch Log Group Building Block Module
# -----------------------------------------------------------------------------
module "log_group" {
  source            = "../../modules/cloudwatch-log-group"
  name              = "/aws/apigateway/${local.api_name}"
  retention_in_days = var.log_retention_in_days

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Invoke Granular API Gateway HTTP Building Block Module
# -----------------------------------------------------------------------------
module "api_gateway" {
  source                     = "../../modules/api-gateway-http"
  name                       = local.api_name
  description                = "HTTP API Gateway for ${var.name_prefix} (${var.environment})"
  stage_name                 = var.stage_name
  access_log_destination_arn = module.log_group.log_group_arn

  cors_allow_credentials = var.cors_allow_credentials
  cors_allow_headers     = var.cors_allow_headers
  cors_allow_methods     = var.cors_allow_methods
  cors_allow_origins     = var.cors_allow_origins
  cors_max_age           = var.cors_max_age

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "Terragrunt"
    }
  )
}
