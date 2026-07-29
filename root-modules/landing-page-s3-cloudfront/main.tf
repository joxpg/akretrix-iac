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
# Invoke Granular S3 Bucket Building Block Module
# -----------------------------------------------------------------------------
module "s3_bucket" {
  source        = "../../modules/s3-bucket"
  bucket_name   = var.bucket_name
  force_destroy = var.force_destroy
  tags          = var.tags
}

# -----------------------------------------------------------------------------
# Invoke Granular CloudFront Distribution Building Block Module
# -----------------------------------------------------------------------------
module "cloudfront" {
  source              = "../../modules/cloudfront-distribution"
  name_prefix         = var.bucket_name
  origin_domain_name  = module.s3_bucket.bucket_regional_domain_name
  price_class         = var.price_class
  custom_domain_names = var.custom_domain_names
  acm_certificate_arn = var.acm_certificate_arn
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Bucket Policy linking S3 and CloudFront OAC
# -----------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "oac_policy" {
  bucket = module.s3_bucket.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${module.s3_bucket.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = module.cloudfront.distribution_arn
          }
        }
      }
    ]
  })
}
