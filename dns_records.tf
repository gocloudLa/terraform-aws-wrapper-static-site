/*----------------------------------------------------------------------*/
/* Static Site Variables                                                */
/*----------------------------------------------------------------------*/
data "aws_route53_zone" "static_site" {
  for_each = local.static_site_route53

  zone_id      = lookup(each.value, "zone_id", null)
  name         = lookup(each.value, "zone_name", null)
  private_zone = lookup(each.value, "private_zone", false)
}

resource "aws_route53_record" "static_site" {
  for_each = local.static_site_route53

  zone_id         = data.aws_route53_zone.static_site[each.key].zone_id
  name            = lookup(each.value, "record_name")
  allow_overwrite = false
  type            = "A"
  alias {
    name                   = module.static-site[each.value.name].domain_cloudfront
    zone_id                = module.static-site[each.value.name].hosted_zone_id
    evaluate_target_health = false
  }
}

locals {
  static_site_route53_tmp = [for resource_name, value1 in var.static_site_parameters :
    {
      for dns_record_name, value2 in value1.dns_records :
      "${resource_name}-${dns_record_name}" =>
      {
        "name"         = resource_name
        "record_name"  = length(try(value2.record_name, dns_record_name)) > 0 ? try(value2.record_name, dns_record_name) == "_null_" ? "" : try(value2.record_name, dns_record_name) : "${local.common_name}-${resource_name}"
        "zone_name"    = value2.zone_name
        "private_zone" = value2.private_zone
        "ttl"          = lookup(value2, "ttl", 300)
      }
    }
    if lookup(value1, "dns_records", null) != null
  ]
  static_site_route53 = merge(local.static_site_route53_tmp...)
}
