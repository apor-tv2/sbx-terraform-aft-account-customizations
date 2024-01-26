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
	source = "https://codestar-connections.eu-central-1.amazonaws.com/git-http/352190605276/eu-central-1/8114a67a-e20b-4dc4-848e-f46d536ca168/apor-tv2/infrastructure-SCPs.git"



	#source = "./modules/infrastructure-SCPs"
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
