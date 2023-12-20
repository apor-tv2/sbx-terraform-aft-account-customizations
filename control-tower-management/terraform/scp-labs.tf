module "scp-sbx-labs" {
	source = "./modules/org_scp/"
	targets = toset([var.ou_targets.labs])
	name = "scp-labs"
	deny_all_except_controltowerexecution = false
	deny_root_account_access     = false
	deny_password_policy_changes = true
	deny_vpn_gateway_changes     = false
	deny_vpc_changes             = false
	deny_config_changes          = true
	# ^5
	deny_cloudtrail_changes      = true
	deny_leave_organization_and_change_billing = false
}
