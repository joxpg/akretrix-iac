include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//root-modules/static-site-s3-cloudfront"
}

inputs = {
  bucket_name = "monitoring-sentinel-dev-static"
  price_class = "PriceClass_100"

  tags = {
    Environment = "dev"
    Component   = "MonitoringSentinel-Frontend"
    Project     = "MonitoringSentinel"
  }
}
