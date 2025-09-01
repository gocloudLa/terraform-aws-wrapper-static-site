/*----------------------------------------------------------------------*/
/* Static Site Variables                                                */
/*----------------------------------------------------------------------*/
module "static_site_lambdas" {
  for_each = local.static_site_lambdas
  source   = "terraform-aws-modules/lambda/aws"
  version  = "8.0.1"

  lambda_at_edge = true

  function_name = "${local.common_name}-${each.key}"
  description   = "Lambda function for ${each.key} in cloudfront distribution"
  source_path   = try(each.value.source_path, "lambdas/${each.value.name}")
  layers        = try(each.value.layers, null)
  handler       = try(each.value.handler, "index.handler")
  runtime       = try(each.value.runtime, "nodejs18.x")
  timeout       = try(each.value.timeout, 5)

  memory_size                       = try(each.value.memory_size, 128)
  ephemeral_storage_size            = try(each.value.ephemeral_storage_size, 512)
  provisioned_concurrent_executions = try(each.value.provisioned_concurrent_executions, -1)
  reserved_concurrent_executions    = try(each.value.reserved_concurrent_executions, -1)

  environment_variables         = try(each.value.environment_variables, {})
  allowed_triggers              = try(each.value.allowed_triggers, {})
  assume_role_policy_statements = try(each.value.assume_role_policy_statements, {})
  attach_policy_json            = try(each.value.attach_policy_json, false)
  policy_json                   = try(each.value.policy_json, "")
  attach_policy_jsons           = try(each.value.attach_policy_jsons, false)
  policy_jsons                  = try(each.value.policy_jsons, [])
  number_of_policy_jsons        = try(each.value.number_of_policy_jsons, 0)
  attach_policy                 = try(each.value.attach_policy, false)
  policy                        = try(each.value.policy, null)
  attach_policies               = try(each.value.attach_policies, false)
  policies                      = try(each.value.policies, [])
  number_of_policies            = try(each.value.number_of_policies, 0)
  attach_policy_statements      = try(each.value.attach_policy_statements, false)
  policy_statements             = try(each.value.policy_statements, {})

  recreate_missing_package = try(each.value.recreate_missing_package, true)

  providers = {
    aws = aws.use1
  }

  tags = merge(local.common_tags, { workload = "${each.key}" })
}

locals {
  static_site_lambdas_tmp = [for resource_name, value1 in var.static_site_parameters :
    {
      for lambda_name, value2 in value1.lambdas :
      "${resource_name}-${lambda_name}" =>
      merge({ "name" = "${lambda_name}" }, value2)
    }
    if lookup(value1, "lambdas", null) != null
  ]
  static_site_lambdas = merge(local.static_site_lambdas_tmp...)
}