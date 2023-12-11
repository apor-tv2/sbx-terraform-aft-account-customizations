data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "bucket" {
  bucket = "aft-mycontroltowermgmtaccount-${data.aws_caller_identity.current.account_id}"
}
