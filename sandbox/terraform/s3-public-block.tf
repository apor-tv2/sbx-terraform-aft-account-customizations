resource "aws_s3_account_public_access_block" "global-block" {
	block_public_acls = true
	block_public_policy = true
}

 test by adding this to bucket policy
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Sid": "public-read",
#            "Effect": "Allow",
#            "Principal": "*",
#            "Action": "s3:GetObject",
#            "Resource": "arn:aws:s3:::tv2-apor-test1/*"
#        }
#    ]
#}
