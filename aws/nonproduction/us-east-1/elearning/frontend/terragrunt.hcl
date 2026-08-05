include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//root-modules/static-site-s3-cloudfront"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

inputs = {
  bucket_name = "${local.env}-akretrix-elearning-static"
  price_class = "PriceClass_100"

  tags = {
    Environment = local.env
    Component   = "eLearning-Frontend"
    Project     = "AkreTrix"
    ManagedBy   = "Terragrunt"
  }
}
