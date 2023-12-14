data "aws_iam_policy_document" "scp_policy" {

  # Root account access
  dynamic "statement" {
    for_each = local.deny_root_account_access_statement
    content {
      sid = "deny root account access"
      actions   = ["*"]
      resources = ["*"]
      effect    = "Deny"
      condition {
        test     = "StringLike"
        variable = "aws:PrincipalArn"
        values   = ["arn:aws:iam::*:root"]
      }
    }
  }

  # IAM password policy changes
  dynamic "statement" {
    for_each = local.deny_password_policy_changes_statement
    content {
      sid = "deny password policy changes"
      actions = [
        "iam:DeleteAccountPasswordPolicy",
        "iam:UpdateAccountPasswordPolicy"
      ]
      resources = ["*"]
      effect    = "Deny"
      condition {
        test     = "ForAnyValue:ArnNotLike"
        variable = "aws:PrincipalArn"
        values = [
          "arn:aws:iam::*:role/Deploy"
        ]
      }
    }
  }


  # AMI
  dynamic "statement" {
    for_each = local.deny_vpn_gateway_changes_statement
    content {
	    sid = "deny vpn gateway changes"
      effect = "Deny"
      actions = [
        "ec2:DetachVpnGateway",
        "ec2:AttachVpnGateway",
        "ec2:DeleteVpnGateway",
        "ec2:CreateVpnGateway"
      ]
      resources = [
        "arn:aws:ec2:*:*:vpn-gateway/*",
        "arn:aws:ec2:*:*:vpc/*"
      ]
      condition {
        test     = "ForAnyValue:ArnNotLike"
        variable = "aws:PrincipalArn"
        values = [
          "arn:aws:iam::*:role/NetworkAdmin",
        ]
      }
    }
  }


  # Deny Network changes
  #
  dynamic "statement" {
    for_each = local.deny_vpc_changes_statement
    content { 
			sid = "deny vpc changes"
      effect = "Deny"
      actions = [
        "ec2:DeleteFlowLogs",
        "ec2:ModifyVpc*",
        "ec2:CreateVpc*",
        "ec2:DeleteVpc*",
        "ec2:AcceptVpcPeeringConnection",
        "ec2:DisassociateVpcCidrBlock"
      ]
      resources = [
        "*"
      ]
      condition {
        test     = "ForAnyValue:ArnNotLike"
        variable = "aws:PrincipalArn"
        values = [
          "arn:aws:iam::*:role/NetworkAdmin",
        ]
      }
    }
  }


  # Config changes for core
  dynamic "statement" {
    for_each = local.deny_config_changes_statement
    content {
			sid = "deny config changes"
      effect = "Deny"
      actions = [
        "config:DeleteConfigurationRecorder",
        "config:DeleteDeliveryChannel",
        "config:DeleteRetentionConfiguration",
        "config:PutConfigurationRecorder",
        "config:PutDeliveryChannel",
        "config:PutRetentionConfiguration",
        "config:StopConfigurationRecorder"
      ]
      resources = ["*"]
      condition {
        test     = "ForAnyValue:ArnNotLike"
        variable = "aws:PrincipalArn"
        values = [
          "arn:aws:iam::*:role/Deploy"
        ]
      }
    }
  }


  # Deny Cloud Trail changes
  dynamic "statement" {
    for_each = local.deny_cloudtrail_changes_statement
    content {
			sid = "deny cloudtrail changes"
      effect = "Deny"
      actions = [
        "cloudtrail:DeleteTrail",
        "cloudtrail:UpdateTrail",
        "cloudtrail:PutEventSelectors",
        "cloudtrail:StopLogging"
      ]
      resources = ["arn:aws:cloudtrail:*:*:trail/*"]
      condition {
        test     = "ForAnyValue:ArnNotLike"
        variable = "aws:PrincipalArn"
        values = [
          "arn:aws:iam::*:role/aws-reserved/sso.amazonaws.com/Deploy"
        ]
      }
    }
  }

  # Deny Leave Organization and Change BillingPreferences
  dynamic "statement" {
    for_each = local.deny_leave_organization_and_change_billing_statement
    content {
      sid = "deny leave organization and change billing"
      effect = "Deny"
      actions = [
        "organizations:LeaveOrganization",
        "billing:UpdateBillingPreferences"
      ]
      resource = "*"
    }
  }
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
