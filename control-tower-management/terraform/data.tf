// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_units" "ou" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

#data "aws_region" "current" {}
#
#data "aws_organizations_organization" "current" {}
#
#data "aws_organizations_organizational_units" "current" {
#  parent_id = data.aws_organizations_organization.current.roots[0].id
#}
