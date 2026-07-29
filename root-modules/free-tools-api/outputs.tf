output "artifact_bucket_name" {
  description = "Name of the S3 bucket created for deployment artifacts."
  value       = module.artifact_bucket.bucket_id
}

output "artifact_bucket_arn" {
  description = "ARN of the S3 bucket created for deployment artifacts."
  value       = module.artifact_bucket.bucket_arn
}
