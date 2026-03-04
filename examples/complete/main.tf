module "static-site" {
  source   = "../.."
  metadata = local.metadata

  providers = {
    aws.use1 = aws.use1
  }

  static_site_parameters = {
    "exsimple" = {
      acm_certificate_arn   = data.aws_acm_certificate.this.arn
      custom_error_response = local.custom_error_response
      # enable_dashboard      = true # Default: false
      dns_records = {
        "" = {
          zone_name    = local.zone_public
          private_zone = false
        }
        # To Generate a Record in the ROOT of the DNS Zone
        # Use _null_ as key
        # "_null_" = {
        #   zone_name    = local.zone_public
        #   private_zone = false
        # } # This Generate for example https://example.com
        # To Generate the same Record in another zone
        # "_null_-alternative" = {
        #   zone_name    = local.zone_public2
        #   private_zone = false
        #   record_name  = "_null_"
        # }
      }
    }
    "exlambda" = {
      acm_certificate_arn   = data.aws_acm_certificate.this.arn
      custom_error_response = local.custom_error_response
      # enable_dashboard      = true # Default: false
      dns_records = {
        "" = {
          zone_name    = local.zone_public
          private_zone = false
        }
      }
      lambdas = {
        "authentication" = {}
      }
      default_cache_behavior = {
        lambda_function_association = {
          "viewer-request" = {
            lambda_name  = "authentication"
            include_body = false
          }
        }
      }
    }
    "excache" = {
      acm_certificate_arn   = data.aws_acm_certificate.this.arn
      custom_error_response = local.custom_error_response
      dns_records = {
        "" = {
          zone_name    = local.zone_public
          private_zone = false
        }
      }
      default_cache_behavior = {
        allowed_methods          = ["GET", "HEAD", "OPTIONS"]
        cached_methods           = ["GET", "HEAD"]
        viewer_protocol_policy   = "allow-all"
        compress                 = true
        cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
        origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # Managed-AllViewer
      }
      ordered_cache_behavior = [
        {
          path_pattern             = "index.html"
          allowed_methods          = ["GET", "HEAD", "OPTIONS"]
          cached_methods           = ["GET", "HEAD"]
          viewer_protocol_policy   = "allow-all"
          compress                 = true
          cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Managed-CachingDisabled
          origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # Managed-AllViewer
        }
      ]
      restrictions = {
        geo_restriction = {
          restriction_type = "whitelist"
          locations        = ["AR"]
        }
      }
    }
    "exwaf" = {
      acm_certificate_arn   = data.aws_acm_certificate.this.arn
      custom_error_response = local.custom_error_response
      # WAF CONFIG
      #web_acl_id           = data.aws_wafv2_web_acl.cloudfront.arn #if you are using wafV2
      dns_records = {
        "" = {
          zone_name    = local.zone_public
          private_zone = false
        }
        # To Generate a Record in the ROOT of the DNS Zone
        # Use _null_ as key
        # "_null_" = {
        #   zone_name    = local.zone_public
        #   private_zone = false
        # } # This Generate for example https://example.com
      }
    }
    "exresponseheaders" = {
      acm_certificate_arn   = data.aws_acm_certificate.this.arn
      custom_error_response = local.custom_error_response
      dns_records = {
        "" = {
          zone_name    = local.zone_public
          private_zone = false
        }
      }
      ordered_cache_behavior = [
        {
          path_pattern             = "index.html"
          allowed_methods          = ["GET", "HEAD", "OPTIONS"]
          cached_methods           = ["GET", "HEAD"]
          viewer_protocol_policy   = "allow-all"
          compress                 = true
          cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Managed-CachingDisabled
          origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # Managed-AllViewer
        },
        {
          path_pattern = "/static/*"
          # target_origin_id       = "s3"
          viewer_protocol_policy = "redirect-to-https"

          allowed_methods = ["GET", "HEAD", "OPTIONS"]
          cached_methods  = ["GET", "HEAD"]

          cache_policy_name          = "Managed-CachingOptimized"
          origin_request_policy_name = "Managed-UserAgentRefererHeaders"
          # response_headers_policy_name = "Managed-SimpleCORS"
          # To use a response headers policy created by this module, use response_headers_policy_key:
          response_headers_policy_key = "cors_policy"
        },
        {
          path_pattern                = "/secure/*"
          allowed_methods             = ["GET", "HEAD", "OPTIONS"]
          cached_methods              = ["GET", "HEAD"]
          viewer_protocol_policy      = "redirect-to-https"
          compress                    = true
          cache_policy_id             = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
          origin_request_policy_id    = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # Managed-AllViewer
          response_headers_policy_key = "custom_security_headers"
        }
      ]
      response_headers_policies = {
        cors_policy = {
          name    = "CORSPolicy"
          comment = "CORS configuration for API"

          cors_config = {
            access_control_allow_credentials = false
            origin_override                  = true

            access_control_allow_headers = {
              items = ["*"]
            }

            access_control_allow_methods = {
              items = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
            }

            access_control_allow_origins = {
              items = ["https://example.com", "https://app.example.com"]
            }

            access_control_expose_headers = {
              items = ["X-Custom-Header", "X-Request-Id"]
            }

            access_control_max_age_sec = 3600
          }
        }
        custom_headers = {
          name    = "CustomHeadersPolicy"
          comment = "Add custom response headers"

          custom_headers_config = {
            items = [
              {
                header   = "X-Powered-By"
                override = true
                value    = "MyApp/1.0"
              },
              {
                header   = "X-API-Version"
                override = false
                value    = "v2"
              },
              {
                header   = "Cache-Control"
                override = true
                value    = "public, max-age=3600"
              }
            ]
          }
        }
        remove_headers = {
          name    = "RemoveHeadersPolicy"
          comment = "Remove unwanted headers from origin"

          remove_headers_config = {
            items = [
              {
                header = "x-robots-tag"
              },
              {
                header = "server"
              },
              {
                header = "x-powered-by"
              }
            ]
          }
        }
        custom_security_headers = {
          name    = "custom-security-headers-policy"
          comment = "Custom response headers policy with Content-Security-Policy for client requirements"
          security_headers_config = {
            content_security_policy = {
              content_security_policy = "frame-ancestors 'self' https://cliente.com https://*.cliente.com http://localhost:5174"
              override                = true
            }
            content_type_options = {
              override = true
            }
            frame_options = {
              frame_option = "SAMEORIGIN"
              override     = true
            }
            referrer_policy = {
              referrer_policy = "strict-origin-when-cross-origin"
              override        = true
            }
            strict_transport_security = {
              access_control_max_age_sec = 31536000
              include_subdomains         = true
              override                   = true
              preload                    = true
            }
          }
        }
      }
    }
  }

  static_site_defaults = var.static_site_defaults
}