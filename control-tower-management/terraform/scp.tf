# data "aws_iam_policy_document" "scp_policy_dynamic" {
# 
#   # Root account access
#   dynamic "statement" {
#     for_each = local.deny_root_account_access_statement
#     content {
#       actions   = ["*"]
#       resources = ["*"]
#       effect    = "Deny"
#       condition {
#         test     = "StringLike"
#         variable = "aws:PrincipalArn"
#         values   = ["arn:aws:iam::*:root"]
#       }
#     }
#   }
#}
#resource "aws_organizations_policy" "scp_dynamic" {
#  name    = "Deny Root Account Access"
#  content = data.aws_iam_policy_document.scp_policy_dynamic.json
#}
#
#data "aws_iam_policy_document" "example" {
#  statement {
#    effect    = "Allow"
#    actions   = ["*"]
#    resources = ["*"]
#  }
#}
#
#resource "aws_organizations_policy" "example" {
#  name    = "Deny Nothing"
#  content = data.aws_iam_policy_document.example.json
#}

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
}
