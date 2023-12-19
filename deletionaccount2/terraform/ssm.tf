data "aws_caller_identity" "current" {}

resource "aws_ssm_parameter" "SSMAccountID" {
	name = "/accID"
	type = "String"
	value = "${data.aws_caller_identity.current.account_id}"
}
