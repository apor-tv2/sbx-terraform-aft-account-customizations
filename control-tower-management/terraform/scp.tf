module "scp_labs" {
	source = "./modules/scp"
	for_each  = fileset(path.root, "policies/scp_labs/*.json")
	json_file = each.value
	ou_list   = var.sandbox_ou
}

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
