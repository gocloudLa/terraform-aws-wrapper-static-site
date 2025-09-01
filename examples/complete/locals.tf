locals {

  metadata = {
    aws_region  = "us-east-1"
    environment = "Production"
    project     = "example"

    public_domain  = "democorp.cloud"
    private_domain = "democorp"

    key = {
      company = "dmc"
      region  = "use1"
      env     = "prd"
      project = "example"
    }
  }

  common_name_prefix = join("-", [
    local.metadata.key.company,
    local.metadata.key.env
  ])

  common_name = join("-", [
    local.common_name_prefix,
    local.metadata.key.project
  ])

  custom_error_response = [
    {
      error_code            = 404 #Not Found
      response_page_path    = "/"
      response_code         = 200
      error_caching_min_ttl = 0
    },
    {
      error_code            = 403 # Forbidden
      response_page_path    = "/"
      response_code         = 200
      error_caching_min_ttl = 0
    }
  ]

}
