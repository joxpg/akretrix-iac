terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "s3_bucket" {
  source              = "../../modules/s3-bucket"
  bucket_name         = var.bucket_name
  force_destroy       = var.force_destroy
  block_public_access = var.block_public_access
  enable_encryption   = var.enable_encryption
  sse_algorithm       = var.sse_algorithm
  tags                = var.tags
}
