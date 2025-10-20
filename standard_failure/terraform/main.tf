locals {
	empty_array = []
	array = [
		{"foo":"bar"},
		{"bim":"bam"}
	]
}

resource "aws_ssm_parameter" "empty_array" {
  for_each = local.empty_array
  name  = "${each.key}"
  type  = "String"
  value = "${each.value}"
}
resource "aws_ssm_parameter" "array" {
  for_each = local.array
  name  = "${each.key}"
  type  = "String"
  value = "${each.value}"
}
