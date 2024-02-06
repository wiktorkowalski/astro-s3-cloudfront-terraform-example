output "bucket_url" {
  value = "s3://${aws_s3_bucket.website_bucket.id}"
}

output "website_url" {
  value = "https://${var.main_domain_name}"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.website_distribution.id
}
