#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_control

# IMPORT Existing SecurityHub account
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_account 
#In Terraform v1.5.0 and later, use an import block to import an existing Security Hub enabled account using the AWS account ID. For example:
#
#import {
#  to = aws_securityhub_account.example
#  id = "123456789012"
#}

#resource "aws_securityhub_account" "example" {}
#
#resource "aws_securityhub_standards_subscription" "cis_aws_foundations_benchmark" {
#  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
#  depends_on    = [aws_securityhub_account.example]
#}
#
#resource "aws_securityhub_standards_control" "ensure_iam_password_policy_prevents_password_reuse" {
#  standards_control_arn = "arn:aws:securityhub:us-east-1:111111111111:control/cis-aws-foundations-benchmark/v/1.2.0/1.10"
#  control_status        = "DISABLED"
#  disabled_reason       = "We handle password policies within Okta"
#
#  depends_on = [aws_securityhub_standards_subscription.cis_aws_foundations_benchmark]
#}

#resource "aws_securityhub_account" "SecurityHubOnAudit" {
#	enable_default_standards = true
#	control_finding_generator = SECURITY_CONTROL
#}
