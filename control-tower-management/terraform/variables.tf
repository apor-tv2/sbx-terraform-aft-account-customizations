// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

#variable "region" {
#  description = "region for deployment"
#  type        = string
#}

#variable "sandbox_ou" {
#  description = "list of sandbox OUs"
#  type        = list(string)
#}

#variable "labs_ou" {
#  description = "list of labs OUs"
#  type        = list(string)
#}

variable "name" {
  description = "SCP name"
  type        = string
}

variable "targets" {
  description = "Lits of OU and account id's to attach SCP"
  type        = set(string)
  default     = []
}

# SCP targets - i.e. the OUs in our AWS Organization
variable "ou_targets" {
  type = map(any)
  default = {
#    "development" = "ou-enen-abcd1234",
#    "production"  = "ou-enen-abcd1236",
    "labs"        = "ou-rzsy-6rzfb9hq"
  }
}

#variable "aws_profile" {
#  type = string
#}

#variable "aws_region" {
#  type = string
#}

# SCP rule toggles

variable "deny_root_account_access" {
  description = "Deny usage of AWS account root"
  default     = false
  type        = bool
}

variable "deny_password_policy_changes" {
  description = "Deny changes to the IAM password policy"
  default     = false
  type        = bool
}

variable "deny_vpn_gateway_changes" {
  description = "Deny changes to VPN gateways"
  default     = false
  type        = bool
}

variable "deny_vpc_changes" {
  description = "Deny VPC related changes"
  default     = false
  type        = bool
}

variable "deny_config_changes" {
  description = "Deny AWS Config related changes"
  default     = false
  type        = bool
}

variable "deny_cloudtrail_changes" {
  description = "Deny AWS CloudTrail related changes"
  default     = false
  type        = bool
}

variable "deny_delete_s3_bucket_statement" {
  description = "Deny Delete S3 Bucket statement"
  default     = false
  type        = bool
}
