# This file may initially be generated with variables.tf.generate.sh that will produce variables.tf.generated

# SCP targets - i.e. the OUs in our AWS Organization
variable "ou_targets" {
  type = map(any)
  default = {
#    "development" = "ou-enen-abcd1234",
#    "production"  = "ou-enen-abcd1236",
    "sbx_suspended" = "ou-rzsy-u2bc3d05",
    "sbx_security" = "ou-rzsy-lolkcqma",
    "sbx_labs" = "ou-rzsy-6rzfb9hq",
    "sbx_sandbox" = "ou-rzsy-wv1o09yh"

  }
}

