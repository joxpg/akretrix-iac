include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//root-modules/static-site-s3-cloudfront"
}

locals {
  certs            = read_terragrunt_config("${get_parent_terragrunt_dir()}/_env-common/certificates.hcl")
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  accountname      = local.environment_vars.locals.accountname
}

inputs = {
  bucket_name = "${local.env}-akretrix-elearning-static"
  price_class = "PriceClass_100"

  # ACM Certificate and custom domain alias for elearning.akretrix.com
  acm_certificate_arn = local.certs.locals.acm_certificates[local.accountname]["us-east-1"].arn
  custom_domain_names = ["elearning.akretrix.com"]

  tags = {
    Environment = local.env
    Component   = "eLearning-Frontend"
    Project     = "AkreTrix"
    ManagedBy   = "Terragrunt"
  }
}
