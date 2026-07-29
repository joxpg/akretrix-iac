include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//root-modules/landing-page-s3-cloudfront"
}

locals {
  certs            = read_terragrunt_config("${get_parent_terragrunt_dir()}/_env-common/certificates.hcl")
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  accountname      = local.environment_vars.locals.accountname
}

inputs = {
  bucket_name = "${local.env}-akretrix-landing-page-static"
  price_class = "PriceClass_100"

  # Dynamically pull the certificate and alias from the central file
  acm_certificate_arn = local.certs.locals.acm_certificates[local.accountname]["us-east-1"].arn
  custom_domain_names = local.certs.locals.acm_certificates[local.accountname]["us-east-1"].aliases

  tags = {
    Environment = local.env
    Component   = "LandingPage-Frontend"
    Project     = "AkreTrix"
  }
}
