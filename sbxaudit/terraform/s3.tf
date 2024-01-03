resource "aws_s3_bucket" "test_bucket" {
  bucket = "aft-${data.aws_caller_identity.current.account_id}"
}
