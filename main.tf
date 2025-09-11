module "static-site" {
  for_each = var.static_site_parameters
  source   = "./modules/aws/terraform-aws-static-site"

  # S3 variables 
  bucket                                = "${local.common_name}-${each.key}"
  create_bucket                         = try(each.value.create_bucket, var.static_site_defaults.create_bucket, true)
  acceleration_status                   = try(each.value.acceleration_status, var.static_site_defaults.acceleration_status, null)
  acl                                   = try(each.value.acl, var.static_site_defaults.acl, null)
  attach_deny_insecure_transport_policy = try(each.value.attach_deny_insecure_transport_policy, var.static_site_defaults.attach_deny_insecure_transport_policy, false)
  attach_policy                         = try(each.value.attach_policy, var.static_site_defaults.attach_policy, false)
  attach_public_policy                  = try(each.value.attach_public_policy, var.static_site_defaults.attach_public_policy, true)
  attach_require_latest_tls_policy      = try(each.value.attach_require_latest_tls_policy, var.static_site_defaults.attach_require_latest_tls_policy, false)
  block_public_acls                     = try(each.value.block_public_acls, var.static_site_defaults.block_public_acls, true)
  block_public_policy                   = try(each.value.block_public_policy, var.static_site_defaults.block_public_policy, true)
  control_object_ownership              = try(each.value.control_object_ownership, var.static_site_defaults.control_object_ownership, false)
  cors_rule                             = try(each.value.cors_rule, var.static_site_defaults.cors_rule, [])
  expected_bucket_owner                 = try(each.value.expected_bucket_owner, var.static_site_defaults.expected_bucket_owner, null)
  force_destroy                         = try(each.value.force_destroy, var.static_site_defaults.force_destroy, true)
  ignore_public_acls                    = try(each.value.ignore_public_acls, var.static_site_defaults.ignore_public_acls, true)
  intelligent_tiering                   = try(each.value.intelligent_tiering, var.static_site_defaults.intelligent_tiering, {})
  lifecycle_rule                        = try(each.value.lifecycle_rule, var.static_site_defaults.lifecycle_rule, [])
  logging                               = try(each.value.logging, var.static_site_defaults.logging, {})
  metric_configuration                  = try(each.value.metric_configuration, var.static_site_defaults.metric_configuration, [])
  object_lock_configuration             = try(each.value.object_lock_configuration, var.static_site_defaults.object_lock_configuration, {})
  object_lock_enabled                   = try(each.value.object_lock_enabled, var.static_site_defaults.object_lock_enabled, false)
  object_ownership                      = try(each.value.object_ownership, var.static_site_defaults.object_ownership, "ObjectWriter")
  policy                                = try(each.value.policy, var.static_site_defaults.policy, null)
  replication_configuration             = try(each.value.replication_configuration, var.static_site_defaults.replication_configuration, {})
  request_payer                         = try(each.value.request_payer, var.static_site_defaults.request_payer, null)
  restrict_public_buckets               = try(each.value.restrict_public_buckets, var.static_site_defaults.restrict_public_buckets, true)
  server_side_encryption_configuration  = try(each.value.server_side_encryption_configuration, var.static_site_defaults.server_side_encryption_configuration, {})
  versioning                            = try(each.value.versioning, var.static_site_defaults.versioning, {})
  website                               = try(each.value.website, var.static_site_defaults.website, {})
  create_log_bucket                     = try(each.value.create_bucket, var.static_site_defaults.create_bucket, true)
  skip_destroy_public_access_block      = try(each.value.skip_destroy_public_access_block, var.defaults.skip_destroy_public_access_block, true)
  
  # cloudfront variables
  create_distribution           = try(each.value.create_distribution, var.static_site_defaults.create_distribution, true)
  create_origin_access_identity = try(each.value.create_origin_access_identity, var.static_site_defaults.create_origin_access_identity, true)
  origin_access_identities = try(each.value.origin_access_identities, var.static_site_defaults.origin_access_identities, {
    "${local.common_name}-${each.key}" = "Application S3 Bucket"
  })
  aliases             = try(each.value.aliases, local.static_site_aliases[each.key], null)
  comment             = try(each.value.comment, var.static_site_defaults.comment, "${local.common_name}-${each.key}")
  default_root_object = try(each.value.default_root_object, var.static_site_defaults.default_root_object, "index.html")
  enabled             = try(each.value.enabled, var.static_site_defaults.enabled, true)
  http_version        = try(each.value.http_version, var.static_site_defaults.http_version, "http2")
  is_ipv6_enabled     = try(each.value.is_ipv6_enabled, var.static_site_defaults.is_ipv6_enabled, true)
  price_class         = try(each.value.price_class, var.static_site_defaults.price_class, "PriceClass_100")
  retain_on_delete    = try(each.value.retain_on_delete, var.static_site_defaults.retain_on_delete, false)
  wait_for_deployment = try(each.value.wait_for_deployment, var.static_site_defaults.wait_for_deployment, false)
  web_acl_id          = try(each.value.web_acl_id, var.static_site_defaults.web_acl_id, null)
  origin              = try(each.value.origin, var.static_site_defaults.origin, {})
  origin_group        = try(each.value.origin_group, var.static_site_defaults.origin_group, {})
  viewer_certificate = try(each.value.viewer_certificate, var.static_site_defaults.viewer_certificate, {
    acm_certificate_arn      = each.value.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  })
  geo_restriction        = try(each.value.geo_restriction, var.static_site_defaults.geo_restriction, {})
  logging_config         = try(each.value.logging_config, var.static_site_defaults.logging_config, {})
  custom_error_response  = try(each.value.custom_error_response, var.static_site_defaults.custom_error_response, {})
  default_cache_behavior = local.default_cache_behavior[each.key]
  ordered_cache_behavior = local.ordered_cache_behavior[each.key]

  create_monitoring_subscription       = try(each.value.create_monitoring_subscription, var.static_site_defaults.create_monitoring_subscription, true)
  realtime_metrics_subscription_status = try(each.value.realtime_metrics_subscription_status, var.static_site_defaults.realtime_metrics_subscription_status, "Enabled")

  acm_certificate_arn = try(each.value.acm_certificate_arn, each.value.acm_certificate_arn, null)

  enable_dashboard = try(each.value.enable_dashboard, var.static_site_defaults.enable_dashboard, false)

  tags = merge(local.common_tags, { workload = "${each.key}" }, try(each.value.tags, var.static_site_defaults.tags, null))

  providers = {
    aws.use1 = aws.use1
  }
}
