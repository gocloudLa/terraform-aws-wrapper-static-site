/*----------------------------------------------------------------------*/
/* Cloudwatch Dashboard                                                 */
/*----------------------------------------------------------------------*/
resource "aws_cloudwatch_dashboard" "static" {
  count          = var.enable_dashboard ? 1 : 0
  dashboard_name = var.bucket
  dashboard_body = local.cloudwatch_dashboard
}

/*----------------------------------------------------------------------*/
/* Template | Cloudwatch Dashboard                                      */
/*----------------------------------------------------------------------*/
locals {
  cloudwatch_dashboard = templatefile("${path.module}/templates/dashboard.tpl", {
    AWS_REGION_CLOUDFRONT      = "us-east-1"
    AWS_REGION_BUCKET          = data.aws_region.current.region
    CLOUDFRONT_DISTRIBUTION_ID = module.cloudfront.cloudfront_distribution_id
    S3_BUCKET_NAME             = module.app_bucket.s3_bucket_id
    S3_ENHANCE_METRIC_NAME     = "EntireBucket"
  })
}

data "aws_canonical_user_id" "current" {}
data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}
