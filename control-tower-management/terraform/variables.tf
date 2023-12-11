// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

#variable "region" {
#  description = "region for deployment"
#  type        = string
#}

#variable "sandbox_ou" {
#  description = "list of sandbox OUs"
#  type        = list(string)
#}

#variable "labs_ou" {
#  description = "list of labs OUs"
#  type        = list(string)
#}

variable "name" {
  description = "SCP name"
  type        = string
}

variable "targets" {
  description = "Lits of OU and account id's to attach SCP"
  type        = set(string)
  default     = []
}
