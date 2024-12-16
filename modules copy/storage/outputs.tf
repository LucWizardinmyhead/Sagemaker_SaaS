output "bucket_name" {
  description = "Bucket name for the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.id
}

output "region" {
  value = data.aws_region.current.name
}