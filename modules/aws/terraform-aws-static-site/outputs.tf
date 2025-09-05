output "domain_cloudfront" {
  value = module.cloudfront.cloudfront_distribution_domain_name
}
output "hosted_zone_id" {
  value = module.cloudfront.cloudfront_distribution_hosted_zone_id
}
output "s3_bucket_bucket_domain_name" {
  value = module.app_bucket.s3_bucket_bucket_domain_name
}