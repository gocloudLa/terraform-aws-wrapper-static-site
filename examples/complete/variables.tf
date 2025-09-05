/*----------------------------------------------------------------------*/
/* Static Site | Variable Definition                                    */
/*----------------------------------------------------------------------*/

variable "static_site_parameters" {
  type        = any
  description = "Static site parameteres to declare values which will be used for each item."
  default     = {}
}

variable "static_site_defaults" {
  type        = any
  description = "Static site default values which will be used for each item."
  default     = {}
}