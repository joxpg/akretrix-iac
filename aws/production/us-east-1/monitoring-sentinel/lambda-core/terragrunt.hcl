include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//root-modules/lambda-function"
}

dependency "api_gateway" {
  config_path = "../api-gateway"

  mock_outputs = {
    api_id        = "mock-api-id"
    execution_arn = "arn:aws:execute-api:us-east-1:123456789012:mock/*"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "graph"]
}

inputs = {
  function_name = "monitoring-sentinel-core"
  environment   = "prod"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  memory_size   = 256
  timeout       = 15

  api_gateway_id             = dependency.api_gateway.outputs.api_id
  api_gateway_execution_arn = dependency.api_gateway.outputs.execution_arn
  route_key                  = "$default"

  environment_variables = {
    NODE_ENV = "production"
  }

  tags = {
    Environment = "prod"
    Component   = "MonitoringSentinel-LambdaCore"
    Project     = "MonitoringSentinel"
  }
}
