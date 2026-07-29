output "s3_bucket_name" {
  description = "Name of the created S3 bucket."
  value       = module.s3_bucket.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket."
  value       = module.s3_bucket.bucket_arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution."
  value       = module.cloudfront.domain_name
}
