resource "aws_ssm_parameter" "SSMAccountID" {
	name = "/accID"
	type = "String"
	value = "${data.aws_caller_identity.current.account_id}"
}

resource "aws_ssm_parameter" "ParamTimestamp" {
	name = "/ParamTimestamp"
	type = "String"
	value = "2023-11-24 14:18"
}
