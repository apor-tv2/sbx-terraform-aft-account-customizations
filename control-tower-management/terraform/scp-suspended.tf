#module "scp-sbx-suspended" {
#	# the source dir is cloned through pre-api-helpers
#	# and deployed version tag is set here
#	# ../api_helpers/git-checkout-with-codestar.sh
#	#source = "git::file:///tmp/infrastructure-SCPs?ref=v1.0.1"
#	#source = "git::file:///tmp/infrastructure-SCPs"
#	# make sure you have an active deploy key
#	source = "git@github.com:tv2/infrastructure-SCPs.git"
#	targets = toset([var.ou_targets.sbx_suspended])
#	name = "scp-suspended"
#	# Rule 1-5
#	deny_all_except_controltowerexecution = false
#	deny_root_account_access     = false
#	deny_password_policy_changes = false
#	deny_vpn_gateway_changes     = false
#	deny_vpc_changes             = false
#	# Rule 5-
#	deny_config_changes          = true
#	deny_cloudtrail_changes      = true
#	deny_leave_organization_and_change_billing = true
#}
