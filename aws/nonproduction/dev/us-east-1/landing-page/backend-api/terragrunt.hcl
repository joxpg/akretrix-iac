include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../root-modules/free-tools-api"
}

inputs = {
  artifact_bucket_name = "akretrix-free-tools-api-artifacts-dev"

  tags = {
    Environment = "dev"
    Component   = "LandingPage-FreeToolsAPI"
    Project     = "AkreTrix"
  }
}
