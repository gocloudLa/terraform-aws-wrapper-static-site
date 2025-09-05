module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "5.0.0"

  aliases             = var.aliases
  comment             = var.comment
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled     //True
  price_class         = var.price_class         //"PriceClass_100"
  retain_on_delete    = var.retain_on_delete    //false
  wait_for_deployment = var.wait_for_deployment //false
  web_acl_id          = var.web_acl_id

  # When you enable additional metrics for a distribution, CloudFront sends up to 8 metrics to CloudWatch in the US East (N. Virginia) Region.
  # This rate is charged only once per month, per metric (up to 8 metrics per distribution).
  create_monitoring_subscription = var.create_monitoring_subscription //true

  create_origin_access_identity = var.create_origin_access_identity //true

  default_root_object = var.default_root_object

  custom_error_response = var.custom_error_response
  viewer_certificate    = var.viewer_certificate
  geo_restriction       = var.geo_restriction

  origin_access_identities = var.origin_access_identities

  logging_config = {
    bucket = module.cloudfront_log_bucket.s3_bucket_bucket_domain_name
    prefix = "cloudfront"
  }

  origin = {
    "${var.bucket}" = {
      domain_name = module.app_bucket.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = var.bucket
      }
    }
  }

  default_cache_behavior = var.default_cache_behavior
  ordered_cache_behavior = var.ordered_cache_behavior

  depends_on = [
    module.app_bucket,
    module.cloudfront_log_bucket
  ]

  tags = var.tags
}

module "app_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.2.0"

  bucket               = var.bucket
  force_destroy        = var.force_destroy
  metric_configuration = local.metric_configuration

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  policy    = var.policy
  cors_rule = var.cors_rule
  website   = var.website
  tags      = var.tags
}

module "cloudfront_log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.2.0"

  create_bucket           = var.create_log_bucket
  bucket                  = "${var.bucket}-cloudfront-logs"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  grant = [{
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_canonical_user_id.current.id
    }, {
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id # Ref. https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
    }
  ]

  owner = {
    id = data.aws_canonical_user_id.current.id
  }

  force_destroy = var.force_destroy

  tags = var.tags
}

###########################
# Origin Access Identities
###########################

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.app_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}