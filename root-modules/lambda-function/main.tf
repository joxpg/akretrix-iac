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
  full_function_name = "${var.function_name}-${var.environment}"
}

# -----------------------------------------------------------------------------
# Invoke Granular IAM Role Building Block Module
# -----------------------------------------------------------------------------
module "lambda_role" {
  source = "../../modules/iam/role"
  name   = "${local.full_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Invoke Granular CloudWatch Log Group Building Block Module
# -----------------------------------------------------------------------------
module "lambda_log_group" {
  source            = "../../modules/cloudwatch-log-group"
  name              = "/aws/lambda/${local.full_function_name}"
  retention_in_days = var.log_retention_in_days

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Invoke Granular Lambda Function Building Block Module
# -----------------------------------------------------------------------------
module "lambda" {
  source        = "../../modules/lambda-function"
  function_name = local.full_function_name
  role_arn      = module.lambda_role.role_arn
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout

  filename         = var.filename
  source_code_hash = var.source_code_hash

  environment_variables = var.environment_variables

  api_gateway_id            = var.api_gateway_id
  api_gateway_execution_arn = var.api_gateway_execution_arn
  route_key                 = var.route_key

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "Terragrunt"
    }
  )

  depends_on = [
    module.lambda_log_group,
    module.lambda_role
  ]
}
