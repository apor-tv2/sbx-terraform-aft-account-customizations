#variable "CodestarGithubInfrastructureSCPsSource" {
#	type = string
#}

#module "scp-sbx-sandbox" {
#	# the source dir is cloned through pre-api-helpers
#	# and deployed version tag is set here
#	# ../api_helpers/git-checkout-with-codestar.sh
#	#source = "git::file:///tmp/infrastructure-SCPs?ref=v1.0.1"
#	#source = "git::file:///tmp/infrastructure-SCPs"
#	source = "git@github.com:tv2/infrastructure-SCPs.git"
#	targets = toset([var.ou_targets.sbx_sandbox])
#	name = "scp-sandbox"
#	# Rule 1-5
#	# THIS IS FOR SUSPSENDED ACCOUNTS
#	deny_all_except_controltowerexecution = false
#	# DISABLE ROOT, So MFA will not be needed anymore
#	deny_root_account_access     = true
#	# to not change password policy, it should be decided by tv2 organization policies only
#	deny_password_policy_changes = false
#	deny_vpn_gateway_changes     = false
#	deny_vpc_changes             = false
#	# Rule 5-
#	deny_config_changes          = true
#	deny_cloudtrail_changes      = false
#	# should not be possible to leave organization, so controltower cannot control account anymore
#	deny_leave_organization_and_change_billing = true
#}
