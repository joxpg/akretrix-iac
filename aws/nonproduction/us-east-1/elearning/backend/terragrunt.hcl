include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//root-modules/s3-bucket"
}

inputs = {
  bucket_name   = "akretrix-elearning-backend-qa"
  force_destroy = false

  tags = {
    Environment = "qa"
    Component   = "Elearning-BackendAPI"
    Project     = "AkreTrix"
  }
}
