data "aws_acm_certificate" "this" {
  domain      = local.zone_public
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

/*----------------------------------------------------------------------*/
/* WAF                                                                  */
/*----------------------------------------------------------------------*/
#data "aws_wafv2_web_acl" "cloudfront" {
#  name  = "waf-name"
#  scope = "CLOUDFRONT"
#}
