#module "scp_sandbox" {
#	source = "https://github.com/aws-samples/aws-scps-with-terraform.git"
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
resource "aws_organizations_policy" "dont_leave" {
	name = "tv2_prevent_leave_organization"
	content = file("tv2_prevent_leave_organization.scp.json")
}
