locals {

  metadata = var.metadata

  common_name_base = join("-", [
    local.metadata.key.company,
    local.metadata.key.env
  ])

  common_name = join("-", [
    local.common_name_base,
    local.metadata.key.project
  ])

  common_tags = {
    "company"     = local.metadata.key.company
    "provisioner" = "terraform"
    "environment" = local.metadata.environment
    "project"     = local.metadata.project
    "created-by"  = "GoCloud.la"
  }

  /*----------------------------------------------------------------------*/
  /* Static Site | Locals Definition                                      */
  /*----------------------------------------------------------------------*/

  static_site_aliases = { for resource_name, value1 in var.static_site_parameters : resource_name =>
    [
      for dns_record_name, value2 in value1.dns_records :
      (try(value2.record_name, dns_record_name)) == "" ?
      "${local.common_name}-${resource_name}.${value2.zone_name}" :
      (try(value2.record_name, dns_record_name)) == "_null_" ?
      "${value2.zone_name}" :
      "${(try(value2.record_name, dns_record_name))}.${value2.zone_name}"
    ]
  }
  cache_behavior_default = {
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
    # Cache key and origin requests
    use_forwarded_values       = false
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id   = "acba4595-bd28-49b8-b9fe-13317c0390fa"
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }
  default_cache_behavior = { for resource_name, value in var.static_site_parameters :
    "${resource_name}" =>
    {
      target_origin_id       = "${local.common_name}-${resource_name}"
      viewer_protocol_policy = try(value.default_cache_behavior.viewer_protocol_policy, local.cache_behavior_default.viewer_protocol_policy)
      allowed_methods        = try(value.default_cache_behavior.allowed_methods, local.cache_behavior_default.allowed_methods)
      cached_methods         = try(value.default_cache_behavior.cached_methods, local.cache_behavior_default.cached_methods)
      compress               = try(value.default_cache_behavior.compress, local.cache_behavior_default.compress)
      query_string           = try(value.default_cache_behavior.query_string, local.cache_behavior_default.query_string)
      # Cache key and origin requests
      use_forwarded_values       = try(value.default_cache_behavior.use_forwarded_values, local.cache_behavior_default.use_forwarded_values)
      cache_policy_id            = try(value.default_cache_behavior.cache_policy_id, local.cache_behavior_default.cache_policy_id)
      origin_request_policy_id   = try(value.default_cache_behavior.origin_request_policy_id, local.cache_behavior_default.origin_request_policy_id)
      response_headers_policy_id = try(value.default_cache_behavior.response_headers_policy_id, local.cache_behavior_default.response_headers_policy_id)

      lambda_function_association = (
        can("${value.default_cache_behavior.lambda_function_association}") ? {
          for key, value in value.default_cache_behavior.lambda_function_association :
          "${key}" => {
            lambda_arn   = module.static_site_lambdas["${resource_name}-${value.lambda_name}"].lambda_function_qualified_arn
            include_body = try(value.include_body, false)
          }
        } : {}
      )
    }
  }
  ordered_cache_behavior = { for resource_name, value1 in var.static_site_parameters :
    "${resource_name}" =>
    [
      for behavior in try(value1.ordered_cache_behavior, []) :
      {
        target_origin_id       = "${local.common_name}-${resource_name}"
        path_pattern           = behavior.path_pattern
        viewer_protocol_policy = try(behavior.viewer_protocol_policy, local.cache_behavior_default.viewer_protocol_policy)

        allowed_methods = try(behavior.allowed_methods, local.cache_behavior_default.allowed_methods)
        cached_methods  = try(behavior.cached_methods, local.cache_behavior_default.cached_methods)
        compress        = try(behavior.compress, local.cache_behavior_default.compress)
        query_string    = try(behavior.query_string, local.cache_behavior_default.query_string)
        # Cache key and origin requests
        use_forwarded_values       = try(behavior.use_forwarded_values, local.cache_behavior_default.use_forwarded_values)
        cache_policy_id            = try(behavior.cache_policy_id, "658327ea-f89d-4fab-a63d-7e88639e58f6")
        origin_request_policy_id   = try(behavior.origin_request_policy_id, "acba4595-bd28-49b8-b9fe-13317c0390fa")
        response_headers_policy_id = try(behavior.response_headers_policy_id, "67f7725c-6f97-4210-82d7-5512b31e9d03")

        lambda_function_association = (
          can("${behavior.lambda_function_association}") ? {
            for key, value in behavior.lambda_function_association :
            "${key}" => {
              lambda_arn   = module.static_site_lambdas["${resource_name}-${value.lambda_name}"].lambda_function_qualified_arn
              include_body = try(value.include_body, false)
            }
          } : {}
        )
      }
    ]
  }
}
