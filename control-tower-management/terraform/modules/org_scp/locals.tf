locals {
  deny_all_except_controltowerexecution_statement = var.deny_all_except_controltowerexecution ? [""] : []
  deny_root_account_access_statement     = var.deny_root_account_access ? [""] : []
  deny_password_policy_changes_statement = var.deny_password_policy_changes ? [""] : []
  deny_vpn_gateway_changes_statement     = var.deny_vpn_gateway_changes ? [""] : []
  deny_vpc_changes_statement             = var.deny_vpc_changes ? [""] : []
  deny_config_changes_statement          = var.deny_config_changes ? [""] : []
  # ^5
  deny_cloudtrail_changes_statement      = var.deny_cloudtrail_changes ? [""] : []
  deny_leave_organization_and_change_billing_statement  = var.deny_leave_organization_and_change_billing ? [""] : []
}
