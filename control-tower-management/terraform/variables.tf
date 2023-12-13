# SCP targets - i.e. the OUs in our AWS Organization
variable "ou_targets" {
  type = map(any)
  default = {
#    "development" = "ou-enen-abcd1234",
#    "production"  = "ou-enen-abcd1236",
    "labs"        = "ou-rzsy-6rzfb9hq"
  }
}
