# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule.html
resource "aws_config_config_rule" "TV2Policy-S3_BUCKET_VERSIONING_ENABLED" {
  name = "TV2Policy-S3_BUCKET_VERSIONING_ENABLED"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.aws-controltower-BaselineConfigRecorder]
  #depends_on = [aws_config_configuration_recorder.foo]
}

resource "aws_config_config_rule" "TV2Policy-MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS" {
  name = "TV2Policy-MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS"

  source {
    owner             = "AWS"
    source_identifier = "MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS"
  }
  depends_on = [aws_config_configuration_recorder.aws-controltower-BaselineConfigRecorder]
}

#resource "aws_config_config_rule" "TV2Policy-IAM_USER_MFA_ENABLED" {
#  name = "TV2Policy-IAM_USER_MFA_ENABLED_TEST"
#
#  source {
#    owner             = "AWS"
#    source_identifier = "IAM_USER_MFA_ENABLED"
#  }
#  depends_on = [aws_config_configuration_recorder.foo]
#}

resource "aws_config_config_rule" "TV2Policy-IAM_USER_MFA_ENABLED" {
  name = "TV2Policy-IAM_USER_MFA_ENABLED"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_MFA_ENABLED"
  }
  depends_on = [aws_config_configuration_recorder.aws-controltower-BaselineConfigRecorder]
}

resource "aws_config_config_rule" "TV2Policy-S3_BUCKET_PUBLIC_READ_PROHIBITED" {
  name = "TV2Policy-S3_BUCKET_PUBLIC_READ_PROHIBITED"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
  depends_on = [aws_config_configuration_recorder.aws-controltower-BaselineConfigRecorder]
}

resource "aws_config_config_rule" "TV2Policy-S3_BUCKET_PUBLIC_WRITE_PROHIBITED" {
  name = "TV2Policy-S3_BUCKET_PUBLIC_WRITE_PROHIBITED"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }
  depends_on = [aws_config_configuration_recorder.aws-controltower-BaselineConfigRecorder]
}

#resource "aws_config_config_rule" "TV2Policy-TEMPLATE" {
#  name = "TV2Policy-TEMPLATE"
#
#  source {
#    owner             = "AWS"
#    source_identifier = "TEMPLATE"
#  }
#  depends_on = [aws_config_configuration_recorder.aws-controltower-BaselineConfigRecorder]
#}
