include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../root-modules/api-gateway"
}

inputs = {
  name_prefix           = "monitoring-sentinel"
  environment           = "dev"
  log_retention_in_days = 14

  cors_allow_origins = ["*"]

  tags = {
    Environment = "dev"
    Component   = "MonitoringSentinel-APIGateway"
    Project     = "MonitoringSentinel"
  }
}
