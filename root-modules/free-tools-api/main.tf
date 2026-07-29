terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# -----------------------------------------------------------------------------
# Invoke Granular S3 Bucket Building Block Module for Artifact Storage
# -----------------------------------------------------------------------------
module "artifact_bucket" {
  source        = "../../modules/s3-bucket"
  bucket_name   = var.artifact_bucket_name
  force_destroy = true
  tags          = var.tags
}
