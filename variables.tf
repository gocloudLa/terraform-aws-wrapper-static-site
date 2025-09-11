/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

variable "metadata" {
  type = any
}

/*----------------------------------------------------------------------*/
/* Static Site | Variable Definition                                    */
/*----------------------------------------------------------------------*/

variable "static_site_parameters" {
  type        = any
  description = "Static site parameteres to declare values which will be used for each item."
  default     = {}
}

variable "static_site_defaults" {
  description = "Static site default values which will be used for each item."
  type        = any
  default     = {}
}

variable "skip_destroy_public_access_block" {
  description = "Whether to skip destroying the S3 Bucket Public Access Block configuration when destroying the bucket. Only used if `public_access_block` is set to true."
  type        = bool
  default     = true
}