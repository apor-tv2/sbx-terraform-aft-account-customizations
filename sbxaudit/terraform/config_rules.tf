# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule.html
resource "aws_config_config_rule" "TV2Policy-S3_BUCKET_VERSIONING_ENABLED" {
  name = "TV2Policy-S3_BUCKET_VERSIONING_ENABLED"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }
  #depends_on = [aws_config_configuration_recorder.aws-controltower-BaselineConfigRecorder]
  depends_on = [aws_config_configuration_recorder.foo]
}
# AWSControlTower-AWS-GR_AUDIT_BUCKET_PUBLIC_READ_PROHIBITED
#acm-certificate-expiration-check
#iam-password-policy
