output "bucket_id" {
  description = "The ID/Name of the S3 bucket."
  value       = module.s3_bucket.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = module.s3_bucket.bucket_arn
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution."
  value       = module.cloudfront.distribution_id
}

output "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution."
  value       = module.cloudfront.distribution_arn
}

output "cloudfront_domain_name" {
  description = "The domain name corresponding to the CloudFront distribution."
  value       = module.cloudfront.domain_name
}
