include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//root-modules/s3-bucket"
}

inputs = {
  bucket_name = "akretrix-landing-page-backend-pdn"
  force_destroy = false

  tags = {
    Environment = "pdn"
    Component   = "LandingPage-BackendAPI"
    Project     = "AkreTrix"
  }
}
