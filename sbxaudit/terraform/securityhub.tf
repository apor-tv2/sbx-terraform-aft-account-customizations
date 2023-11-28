resource "aws_securityhub_account" "SecurityHubOnAudit" {
	enable_default_standards = true
	control_finding_generator = SECURITY_CONTROL
}
