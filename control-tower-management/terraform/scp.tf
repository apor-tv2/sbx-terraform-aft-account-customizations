module "scp-sbx-labs" {
	source = "./modules/org_scp/"
	targets = toset([var.ou_targets.labs])
	name = "scp-labs"
	deny_root_account_access     = false
	deny_password_policy_changes = true
	deny_vpn_gateway_changes     = true
	deny_vpc_changes             = false
	deny_config_changes          = true
	# ^5
	deny_cloudtrail_changes      = false
	deny_leave_organization_and_change_billing = true
}
