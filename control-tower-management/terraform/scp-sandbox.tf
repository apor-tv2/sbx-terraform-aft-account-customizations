variable "TEST" {
	type = string
	default = "Unset"
}

output "printtestvar"{
	value = "${var.TEST}"
}

#variable "CodestarGithubInfrastructureSCPsSource" {
#	type = string
#	description = "Codestar Connection to checkout module source, will be set by pre-api-helpers as TF_VAR_CodestarGithubInfrastructureSCPsSource"
#}

#module "scp-sbx-sandbox" {
#	source = var.CodestarGithubInfrastructureSCPsSource
#	#source = "git::https://git@github.com/tv2/infrastructure-SCPs.git?ref=v1.0.1"
#	#source = "git::https://git@github.com/tv2/infrastructure-SCPs.git"
#
#	# test with a codestar connection from control-tower-account
#	#source = "git::https://git@github.com/apor-tv2/infrastructure-SCPs.git"
#
#	#source = "git::https://github.com/apor-tv2/infrastructure-SCPs.git"
##source = "git@github.com:org/module"
#	#source = "./modules/org_scp/"
#	targets = toset([var.ou_targets.sandbox])
#	name = "scp-sandbox"
#	# Rule 1-5
#	deny_all_except_controltowerexecution = false
#	deny_root_account_access     = true
#	deny_password_policy_changes = true
#	deny_vpn_gateway_changes     = false
#	deny_vpc_changes             = false
#	# Rule 5-
#	deny_config_changes          = true
#	deny_cloudtrail_changes      = true
#	deny_leave_organization_and_change_billing = true
#}
