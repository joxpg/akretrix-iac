include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../root-modules/api-gateway"
}

inputs = {
  name_prefix           = "monitoring-sentinel"
  environment           = "prod"
  log_retention_in_days = 30

  cors_allow_origins = ["*"]

  tags = {
    Environment = "prod"
    Component   = "MonitoringSentinel-APIGateway"
    Project     = "MonitoringSentinel"
  }
}
