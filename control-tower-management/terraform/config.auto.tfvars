// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

region = "eu-central-1"

# list of OUs to deploy the SCPs to, eg ["ou-ab1-12345", "ou-cd2-67890""]
# any .json policy added to the correct directory in /policies will be applied
#tenant_ou  = [""]
#sandbox_ou = [""]
#labs_ou = ["ou-rzsy-6rzfb9hq"]
targets = ["ou-rzsy-6rzfb9hq"]

name = "protect-bucket"
