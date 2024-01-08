data "aws_region" "current" {}

data "aws_organizations_organization" "current" {}

data "aws_organizations_organizational_units" "current" {
  parent_id = data.aws_organizations_organization.current.roots[0].id
}

#resource "aws_controltower_control" "current" {
#  control_identifier = "arn:aws:controltower:${data.aws_region.current.name}::control/AWS-GR_EC2_VOLUME_INUSE_CHECK"
#  target_identifier = [
#    for x in data.aws_organizations_organizational_units.current.children :
#    x.arn if x.name == "Infrastructure"
#  ][0]
#}

#  "arn:aws:organizations::123456789101:ou/o-qqaejywet/ou-qg5o-ufbhdtv3,arn:aws:controltower:eu-central-1::control/WTDSMKDKDNLE"
#}

# Manually enabled in prod-AFT for stage and production
# [AWS-GR_MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS] Detect whether MFA is enabled for AWS IAM users of the AWS Console
#[AWS-GR_IAM_USER_MFA_ENABLED] Detect whether MFA is enabled for AWS IAM users
