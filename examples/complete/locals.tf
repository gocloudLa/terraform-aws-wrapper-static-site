locals {

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
