import {
  to = aws_config_configuration_recorder.aws-controltower-BaselineConfigRecorder
  #to = aws_config_configuration_recorder.foo
  id = "aws-controltower-BaselineConfigRecorder"
}
resource "aws_config_configuration_recorder" "aws-controltower-BaselineConfigRecorder" {
  name     = "aws-controltower-BaselineConfigRecorder"
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"
  recording_group {
    all_supported = true
    include_global_resource_types = true # conflicts with resource_types

#    resource_types = []
#
#    exclusion_by_resource_types {
#      #resource_types = ["AWS::EC2::Instance"]
#      resource_types = []
#    }
#
#    recording_strategy {
#      use_only = "ALL_SUPPORTED_RESOURCE_TYPES"
#      #use_only = "EXCLUSION_BY_RESOURCE_TYPES"
#    }
  }
}

import {
  #to = aws_config_configuration_recorder.aws-controltower-BaselineConfigRecorder
  to = aws_config_configuration_recorder.foo
  id = "aws-controltower-BaselineConfigRecorder"
}
resource "aws_config_configuration_recorder" "foo" {
#resource "aws_config_configuration_recorder" "aws-controltower-BaselineConfigRecorder" {
  name     = "aws-controltower-BaselineConfigRecorder"
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"
  recording_group {
    all_supported = true
    include_global_resource_types = true # conflicts with resource_types

#    resource_types = []
#
#    exclusion_by_resource_types {
#      #resource_types = ["AWS::EC2::Instance"]
#      resource_types = []
#    }
#
#    recording_strategy {
#      use_only = "ALL_SUPPORTED_RESOURCE_TYPES"
#      #use_only = "EXCLUSION_BY_RESOURCE_TYPES"
#    }
  }
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder#argument-reference
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "r" {
  name               = "my-awsconfig-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "p" {
  statement {
    effect    = "Allow"
    actions   = ["config:Put*"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "p" {
  name   = "my-awsconfig-policy"
  role   = aws_iam_role.r.id
  policy = data.aws_iam_policy_document.p.json
}

