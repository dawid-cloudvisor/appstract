output "bucket_ids" {
  description = "IDs of the created S3 buckets"
  value       = aws_s3_bucket.bucket[*].id
}

output "bucket_arns" {
  description = "ARNs of the created S3 buckets"
  value       = aws_s3_bucket.bucket[*].arn
}

output "bucket_names" {
  description = "Names of the created S3 buckets"
  value       = aws_s3_bucket.bucket[*].bucket
}

output "bucket_domain_names" {
  description = "Domain names of the created S3 buckets"
  value       = aws_s3_bucket.bucket[*].bucket_domain_name
}

output "bucket_regional_domain_names" {
  description = "Regional domain names of the created S3 buckets"
  value       = aws_s3_bucket.bucket[*].bucket_regional_domain_name
}
