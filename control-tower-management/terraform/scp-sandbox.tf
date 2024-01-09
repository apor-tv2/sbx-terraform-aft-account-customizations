module "scp-sbx-sandbox" {
	source = "git::https://github.com/tv2/infrastructure-SCPs.git?ref=v1.0.1"
	targets = toset([var.ou_targets.sandbox])
	name = "scp-sandbox"
	# Rule 1-5
	deny_all_except_controltowerexecution = false
	deny_root_account_access     = true
	deny_password_policy_changes = true
	deny_vpn_gateway_changes     = false
	deny_vpc_changes             = false
	# Rule 5-
	deny_config_changes          = true
	deny_cloudtrail_changes      = true
	deny_leave_organization_and_change_billing = true
}
