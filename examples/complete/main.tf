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
      geo_restriction = {
        restriction_type = "whitelist"
        locations        = ["AR"]
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
        # Para Generar un registro en la RAIZ de la Zona DNS
        # Utilizar como key _null_ 
        # "_null_" = {
        #   zone_name    = local.zone_public
        #   private_zone = false
        # } # Esto genera por Ej. https://example.com
      }
    }
  }

  static_site_defaults = var.static_site_defaults
}