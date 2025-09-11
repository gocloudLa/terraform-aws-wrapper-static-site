/*----------------------------------------------------------------------*/
/* Cloudfront | Variable Definition                                    */
/*----------------------------------------------------------------------*/
variable "create_distribution" {
  description = "Controls if CloudFront distribution should be created"
  type        = bool
  default     = true
}

variable "create_origin_access_identity" {
  description = "Controls if CloudFront origin access identity should be created"
  type        = bool
  default     = false
}

variable "origin_access_identities" {
  description = "Map of CloudFront origin access identities (value as a comment)"
  type        = map(string)
  default     = {}
}

variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  type        = list(string)
  default     = null
}

variable "comment" {
  description = "Any comments you want to include about the distribution."
  type        = string
  default     = null
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content."
  type        = bool
  default     = true
}

variable "http_version" {
  description = "The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2."
  type        = string
  default     = "http2"
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution."
  type        = bool
  default     = null
}

variable "price_class" {
  description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  type        = string
  default     = null
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards."
  type        = bool
  default     = false
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this to false will skip the process."
  type        = bool
  default     = true
}

variable "web_acl_id" {
  description = "If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = null
}

variable "origin" {
  description = "One or more origins for this distribution (multiples allowed)."
  type        = any
  default     = null
}

variable "origin_group" {
  description = "One or more origin_group for this distribution (multiples allowed)."
  type        = any
  default     = {}
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type        = any
  default = {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}

variable "geo_restriction" {
  description = "The restriction configuration for this distribution (geo_restrictions)"
  type        = any
  default     = {}
}

variable "logging_config" {
  description = "The logging configuration that controls how logs are written to your distribution (maximum one)."
  type        = any
  default     = {}
}

variable "custom_error_response" {
  description = "One or more custom error response elements"
  type        = any
  default     = {}
}

variable "default_cache_behavior" {
  description = "The default cache behavior for this distribution"
  type        = any
  default     = null
}

variable "ordered_cache_behavior" {
  description = "An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0."
  type        = any
  default     = []
}

variable "create_monitoring_subscription" {
  description = "If enabled, the resource for monitoring subscription will created."
  type        = bool
  default     = false
}

variable "realtime_metrics_subscription_status" {
  description = "A flag that indicates whether additional CloudWatch metrics are enabled for a given CloudFront distribution. Valid values are `Enabled` and `Disabled`."
  type        = string
  default     = "Enabled"
}

variable "acm_certificate_arn" {
  type = string
}

/*----------------------------------------------------------------------*/
/* Bucket | Variable Definition                                    */
/*----------------------------------------------------------------------*/

variable "create_bucket" {
  description = "Controls if S3 bucket should be created"
  type        = bool
  default     = true
}

variable "create_log_bucket" {
  description = "Controls if S3 Cloudfron log bucket should be created"
  type        = bool
  default     = true
}

variable "attach_elb_log_delivery_policy" {
  description = "Controls if S3 bucket should have ELB log delivery policy attached"
  type        = bool
  default     = false
}

variable "attach_lb_log_delivery_policy" {
  description = "Controls if S3 bucket should have ALB/NLB log delivery policy attached"
  type        = bool
  default     = false
}

variable "attach_deny_insecure_transport_policy" {
  description = "Controls if S3 bucket should have deny non-SSL transport policy attached"
  type        = bool
  default     = false
}

variable "attach_require_latest_tls_policy" {
  description = "Controls if S3 bucket should require the latest version of TLS"
  type        = bool
  default     = false
}

variable "attach_policy" {
  description = "Controls if S3 bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy)"
  type        = bool
  default     = false
}

variable "attach_public_policy" {
  description = "Controls if a user defined public bucket policy will be attached (set to `false` to allow upstream to apply defaults to the bucket)"
  type        = bool
  default     = true
}

variable "attach_inventory_destination_policy" {
  description = "Controls if S3 bucket should have bucket inventory destination policy attached."
  type        = bool
  default     = false
}

variable "bucket" {
  description = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "bucket_prefix" {
  description = "(Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
  type        = string
  default     = null
}

variable "acl" {
  description = "(Optional) The canned ACL to apply. Conflicts with `grant`"
  type        = string
  default     = null
}

variable "policy" {
  description = "(Optional) A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "acceleration_status" {
  description = "(Optional) Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended."
  type        = string
  default     = null
}

variable "request_payer" {
  description = "(Optional) Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. By default, the owner of the S3 bucket would incur the costs of any data transfer. See Requester Pays Buckets developer guide for more information."
  type        = string
  default     = null
}

variable "website" {
  description = "Map containing static web-site hosting or redirect configuration."
  type        = any # map(string)
  default     = {}
}

variable "cors_rule" {
  description = "List of maps containing rules for Cross-Origin Resource Sharing."
  type        = any
  default     = []
}

variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
  default     = {}
}

variable "logging" {
  description = "Map containing access bucket logging configuration."
  type        = any
  default     = {}
}

variable "grant" {
  description = "An ACL policy grant. Conflicts with `acl`"
  type        = any
  default     = []
}

variable "owner" {
  description = "Bucket owner's display name and ID. Conflicts with `acl`"
  type        = map(string)
  default     = {}
}

variable "expected_bucket_owner" {
  description = "The account ID of the expected bucket owner"
  type        = string
  default     = null
}

variable "lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}

variable "replication_configuration" {
  description = "Map containing cross-region replication configuration."
  type        = any
  default     = {}
}

variable "server_side_encryption_configuration" {
  description = "Map containing server-side encryption configuration."
  type        = any
  default     = {}
}

variable "intelligent_tiering" {
  description = "Map containing intelligent tiering configuration."
  type        = any
  default     = {}
}

variable "object_lock_configuration" {
  description = "Map containing S3 object locking configuration."
  type        = any
  default     = {}
}

variable "metric_configuration" {
  description = "Map containing bucket metric configuration."
  type        = any
  default     = []
}

variable "inventory_configuration" {
  description = "Map containing S3 inventory configuration."
  type        = any
  default     = {}
}

variable "inventory_source_account_id" {
  description = "The inventory source account id."
  type        = string
  default     = null
}

variable "inventory_source_bucket_arn" {
  description = "The inventory source bucket ARN."
  type        = string
  default     = null
}

variable "inventory_self_source_destination" {
  description = "Whether or not the inventory source bucket is also the destination bucket."
  type        = bool
  default     = false
}

variable "object_lock_enabled" {
  description = "Whether S3 bucket should have an Object Lock configuration enabled."
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "skip_destroy_public_access_block" {
  description = "Whether to skip destroying the S3 Bucket Public Access Block configuration when destroying the bucket. Only used if `public_access_block` is set to true."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "control_object_ownership" {
  description = "Whether to manage S3 Bucket Ownership Controls on this bucket."
  type        = bool
  default     = false
}

variable "object_ownership" {
  description = "Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL."
  type        = string
  default     = "BucketOwnerEnforced"
}

variable "putin_khuylo" {
  description = "Do you agree that Putin doesn't respect Ukrainian sovereignty and territorial integrity? More info: https://en.wikipedia.org/wiki/Putin_khuylo!"
  type        = bool
  default     = true
}

variable "enable_dashboard" {
  description = "Create dashboard cloudwatch"
  type        = bool
  default     = false
}