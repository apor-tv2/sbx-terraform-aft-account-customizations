module "scp-sbx-labs" {
	source = "./modules/org_scp/"
	#targets = toset(["foo"],["bar"])
	targets = toset([var.ou_targets.labs])
	name = "scp-labs"
	deny_root_account_access     = true
	deny_password_policy_changes = true
	deny_vpn_gateway_changes     = true
	deny_vpc_changes             = true
	deny_config_changes          = true
	deny_cloudtrail_changes      = true
	deny_leave_organization_and_change_billing_statement  = true
}
