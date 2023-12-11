#module "scp_labs" {
#	source = "./modules/scp"
#	for_each  = fileset(path.root, "policies/scp_labs/*.json")
#	json_file = each.value
#	ou_list   = var.sandbox_ou
#}

#module "scp_sandbox" {
#	//source = "https://github.com/aws-samples/aws-scps-with-terraform.git"
#	source = "./modules/scp"
#	for_each  = fileset(path.root, "policies/scp_sandbox/*.json")
#	json_file = each.value
#	ou_list   = var.sandbox_ou
#}


#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Action": [
#                "organizations:LeaveOrganization"
#            ],
#            "Resource": "*",
#            "Effect": "Deny"
#        }
#    ]
#}

#resource "aws_organizations_policy" "dont_leave" {
#	name = "tv2_prevent_leave_organization"
#	content = file("tv2_prevent_leave_organization.scp.json")
#}

#data "aws_iam_policy_document" "scp_policy_original" {
#
#  # Root account access
#  dynamic "statement" {
#    for_each = local.deny_root_account_access_statement
#    content {
#      actions   = ["*"]
#      resources = ["*"]
#      effect    = "Deny"
#      condition {
#        test     = "StringLike"
#        variable = "aws:PrincipalArn"
#        values   = ["arn:aws:iam::*:root"]
#      }
#    }
#  }
#
#  # IAM password policy changes
#  dynamic "statement" {
#    for_each = local.deny_password_policy_changes_statement
#    content {
#      actions = [
#        "iam:DeleteAccountPasswordPolicy",
#        "iam:UpdateAccountPasswordPolicy"
#      ]
#      resources = ["*"]
#      effect    = "Deny"
#      condition {
#        test     = "ForAnyValue:ArnNotLike"
#        variable = "aws:PrincipalArn"
#        values = [
#          "arn:aws:iam::*:role/Deploy"
#        ]
#      }
#    }
#  }
#
#
#  # AMI
#  dynamic "statement" {
#    for_each = local.deny_vpn_gateway_changes_statement
#    content {
#      effect = "Deny"
#      actions = [
#        "ec2:DetachVpnGateway",
#        "ec2:AttachVpnGateway",
#        "ec2:DeleteVpnGateway",
#        "ec2:CreateVpnGateway"
#      ]
#      resources = [
#        "arn:aws:ec2:*:*:vpn-gateway/*",
#        "arn:aws:ec2:*:*:vpc/*"
#      ]
#      condition {
#        test     = "ForAnyValue:ArnNotLike"
#        variable = "aws:PrincipalArn"
#        values = [
#          "arn:aws:iam::*:role/NetworkAdmin",
#        ]
#      }
#    }
#  }
#
#
#  # Deny Network changes
#  #
#  dynamic "statement" {
#    for_each = local.deny_vpc_changes_statement
#    content {
#      effect = "Deny"
#      actions = [
#        "ec2:DeleteFlowLogs",
#        "ec2:ModifyVpc*",
#        "ec2:CreateVpc*",
#        "ec2:DeleteVpc*",
#        "ec2:AcceptVpcPeeringConnection",
#        "ec2:DisassociateVpcCidrBlock"
#      ]
#      resources = [
#        "*"
#      ]
#      condition {
#        test     = "ForAnyValue:ArnNotLike"
#        variable = "aws:PrincipalArn"
#        values = [
#          "arn:aws:iam::*:role/NetworkAdmin",
#        ]
#      }
#    }
#  }
#
#
#  # Config changes for core
#  dynamic "statement" {
#    for_each = local.deny_config_changes_statement
#    content {
#      effect = "Deny"
#      actions = [
#        "config:DeleteConfigurationRecorder",
#        "config:DeleteDeliveryChannel",
#        "config:DeleteRetentionConfiguration",
#        "config:PutConfigurationRecorder",
#        "config:PutDeliveryChannel",
#        "config:PutRetentionConfiguration",
#        "config:StopConfigurationRecorder"
#      ]
#      resources = ["*"]
#      condition {
#        test     = "ForAnyValue:ArnNotLike"
#        variable = "aws:PrincipalArn"
#        values = [
#          "arn:aws:iam::*:role/Deploy"
#        ]
#      }
#    }
#  }
#
#
#  # Deny Cloud Trail changes
#  dynamic "statement" {
#    for_each = local.deny_cloudtrail_changes_statement
#    content {
#      effect = "Deny"
#      actions = [
#        "cloudtrail:DeleteTrail",
#        "cloudtrail:UpdateTrail",
#        "cloudtrail:PutEventSelectors",
#        "cloudtrail:StopLogging"
#      ]
#      resources = ["arn:aws:cloudtrail:*:*:trail/*"]
#      condition {
#        test     = "ForAnyValue:ArnNotLike"
#        variable = "aws:PrincipalArn"
#        values = [
#          "arn:aws:iam::*:role/aws-reserved/sso.amazonaws.com/Deploy"
#        ]
#      }
#    }
#  }
#
#}

data "aws_iam_policy_document" "scp_document" {
	policy = file("policies/protect_bucket.json")
}


# Generate the SCP Policy
resource "aws_organizations_policy" "scp_document" {
  name        = var.name
  description = "${var.name} : SCP generated by org-scp module"
  content     = data.aws_iam_policy_document.scp_policy.json
}

# Create the attachment for the targets
resource "aws_organizations_policy_attachment" "scp_attachment" {
  for_each  = var.targets
  policy_id = aws_organizations_policy.scp_document.id
  target_id = each.value
}
