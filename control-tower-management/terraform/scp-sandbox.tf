#variable "CodestarGithubInfrastructureSCPsSource" {
#	type = string
#}

module "scp-sbx-sandbox" {

	# if using clean git urls, make sure credential.helper is set up
	#source = "REPLACECodestarGithubInfrastructureSCPsSourceREPLACE"
	#source = "git::https://git@github.com/tv2/infrastructure-SCPs.git?ref=v1.0.1"
	#source = "git::https://git@github.com/tv2/infrastructure-SCPs.git"

	# test with a codestar connection from control-tower-account
	#source = "git::https://git@github.com/apor-tv2/infrastructure-SCPs.git"

	#source = "git::https://github.com/apor-tv2/infrastructure-SCPs.git"



	#source = "git@github.com:apor-tv2/infrastructure-SCPs.git"
	#source = "git@github.com:org/tv2/infrastructure-SCPs.git"
	#source = "https://codestar-connections.eu-central-1.amazonaws.com/git-http/352190605276/eu-central-1/2f69a125-211b-4890-8e41-813e32d9fe9e/tv2/infrastructure-SCPs.git"

#aportv2-infrastructure-SCPs	GitHub	
#Available
#arn:aws:codestar-connections:eu-central-1:090836393813:connection/42311cd6-9ee2-4f28-a572-4fdc1fbe719d
#tv2-infrastructure-SCPs	GitHub	
#Available
#arn:aws:codestar-connections:eu-central-1:090836393813:connection/2f69a125-211b-4890-8e41-813e32d9fe9e


	# the source dir is checked out through pre-api-helpers
	# and deployed version tag is set in
	# ../api_helpers/git-checkout-with-codestar.sh
	#source = "./modules/infrastructure-SCPs"
	source = "git::file:///tmp/infrastructure-SCPs?ref=v1.0.0"
	targets = toset([var.ou_targets.sandbox])
	name = "scp-sandbox"
	# Rule 1-5
	# THIS IS FOR SUSPSENDED ACCOUNTS
	deny_all_except_controltowerexecution = false
	# DISABLE ROOT, So MFA will not be needed anymore
	deny_root_account_access     = true
	# to not change password policy, it should be decided by tv2 organization policies only
	deny_password_policy_changes = true
	deny_vpn_gateway_changes     = false
	deny_vpc_changes             = false
	# Rule 5-
	deny_config_changes          = true
	deny_cloudtrail_changes      = true
	# should not be possible to leave organization, so controltower cannot control account anymore
	deny_leave_organization_and_change_billing = true
}
