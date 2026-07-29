include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../root-modules/landing-page-s3-cloudfront"
}

inputs = {
  bucket_name = "akretrix-landing-page-dev-static"
  price_class = "PriceClass_100"

  tags = {
    Environment = "dev"
    Component   = "LandingPage-Frontend"
    Project     = "AkreTrix"
  }
}
