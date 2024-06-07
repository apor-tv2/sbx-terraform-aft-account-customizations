variable "tg_in_region" {
    type = map
    default = {
        eu-central-1    = "tgw-0c7da5d42d66e93c5"
        eu-north-1      = "tgw-0ad009b8785b58ed0"
    }
}

variable "tg_rt" {
    type = map
        default = {
            eu-central-1 = {
             prod           = "tgw-rtb-0617e82ee238231cd"
             stage          = "tgw-rtb-08e760e4ef7aae3b3"
             dev            = "tgw-rtb-038a6037599eeb815"
             shared         = "tgw-rtb-0da86508731a17f51"
             internal_test  = "tgw-rtb-09f15a8d37881d73b"
             tv_prod        = "tgw-rtb-0bcf8130ecfe705d5"
            }

            eu-north-1 = {
             prod           = "tgw-rtb-0d9f213d213027e14"
             stage          = "tgw-rtb-03bbd24b770c42151"
             dev            = "tgw-rtb-04a4f1c76105b3690"
             shared         = "tgw-rtb-0a8abca644e28b95e"
             tv_prod        = "tgw-rtb-0de7dac9bfcccfdd9"
            }
        }
}

variable "tg_ram_name" {
    type = map
    default = {
        eu-central-1    = "Share Transitgateway Frankfurt"
        eu-north-1      = "Share Transitgateway Stockholm"
    }
}
locals {
  subnet_letter = ["a", "b", "c"]
  availability_zone = ["${data.aws_region.current.id}a", "${data.aws_region.current.id}b", "${data.aws_region.current.id}c"]
  aft_ssm_custom_fields_prefix = "/aft/account-request/custom-fields"
}

variable "sso_hoejste_permission_set" {                                                            
  type = map
  default = {
     AWSAdministratorAccess = ["AWSAdministratorAccess", "TV2_SuperUser", "TV2_ReadOnly"]       
     TV2_SuperUser = ["TV2_SuperUser", "TV2_ReadOnly"]
     TV2_ReadOnly = ["TV2_ReadOnly"]
     Billing = ["Billing"]                                                                         
  }
}


data "aws_region" "current" {}
output NetworkCurrentRegion {
        value = data.aws_region.current
}

data "aws_ssm_parameter" "create_vpc_and_subnets" {
	name = "${local.aft_ssm_custom_fields_prefix}/create_vpc_and_subnets"
}
data "aws_ssm_parameter" "vpc_cidr" {
	name = "${local.aft_ssm_custom_fields_prefix}/vpc_cidr"
}
output VPCCIDR {
        value = data.aws_ssm_parameter.vpc_cidr.value
        sensitive = true
}
resource "aws_vpc" "vpc" {
  # create the resource if create_vpc_and_subnets == "yes" and vpc_cidr is non-empty
	#count = data.aws_ssm_parameter.create_vpc_and_subnets.value == "yes" && length(data.aws_ssm_parameter.vpc_cidr.value) > 0 ? 1 : 0 )
	#count = (data.aws_ssm_parameter.create_vpc_and_subnets.value == "yes" ? 1 : 0 )
	cidr_block = data.aws_ssm_parameter.vpc_cidr.value
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
}

#resource "aws_subnet" "subnets" {
#  count = length(var.subnets)
#  vpc_id     = aws_vpc.vpc.id
#  cidr_block = var.subnets[count.index]
#  availability_zone = "${module.gvar.availability_zone[count.index]}"
#  tags = {
#    Name = "subnet ${local.subnet_letter[count.index]} ${var.subnets[count.index]} Privat" 
#  }
#  lifecycle {
#    ignore_changes = [tags]
#  }
#}

# private subnets
data "aws_ssm_parameter" "vpc_cidr_private_AZa" {
	name = "${local.aft_ssm_custom_fields_prefix}/vpc_cidr_private_AZa" 
}
resource "aws_subnet" "private_subnet_a" {
	vpc_id = aws_vpc.vpc.id
	cidr_block = data.aws_ssm_parameter.vpc_cidr_private_AZa.value
  availability_zone = "${data.aws_region.current.id}a"
  lifecycle {
          ignore_changes = [tags]
  }
}
#resource "aws_route_table" "rt" {
#        vpc_id = aws_vpc.vpc.id
#}


#data "aws_ssm_parameter" "vpc_cidr_private_AZb" {
#        name = "${local.aft_ssm_custom_fields_prefix}/vpc_cidr_private_AZb" 
#}
#resource "aws_subnet" "private_subnet_b" {
#	vpc_id = aws_vpc.vpc.id
#	cidr_block = data.aws_ssm_parameter.vpc_cidr_private_AZb.value
#        availability_zone = "${data.aws_region.current}b"
#        lifecycle {
#                ignore_changes = [tags]
#        }
#}
#data "aws_ssm_parameter" "vpc_cidr_private_AZc" {
#        name = "${local.aft_ssm_custom_fields_prefix}/vpc_cidr_private_AZc" 
#}
#resource "aws_subnet" "private_subnet_c" {
#	vpc_id = aws_vpc.vpc.id
#	cidr_block = data.aws_ssm_parameter.vpc_cidr_private_AZc.value
#        availability_zone = "${data.aws_region.current}c"
#        lifecycle {
#                ignore_changes = [tags]
#        }
#}




## public subnets
#data "aws_ssm_parameter" "vpc_cidr_public_AZa" {
#}
#resource "aws_subnet" "public_subnet_a" {
#	vpc_id = aws_vpc.vpc.id
#	cidr_block = data.aws_ssm_parameter.vpc_cidr_public_AZa.value
#}
#data "aws_ssm_parameter" "vpc_cidr_public_AZb" {
#}
#resource "aws_subnet" "public_subnet_b" {
#	vpc_id = aws_vpc.vpc.id
#	cidr_block = data.aws_ssm_parameter.vpc_cidr_public_AZb.value
#}
#data "aws_ssm_parameter" "vpc_cidr_public_AZc" {
#}
#resource "aws_subnet" "public_subnet_c" {
#	vpc_id = aws_vpc.vpc.id
#	cidr_block = data.aws_ssm_parameter.vpc_cidr_public_AZc.value
#}



# INFO: Consider fot the future: VPC with CIDR from AWS IPAM:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc


# vpc_cidr: "10.64.18.0/23"
# vpc_cidr_private: "10.64.18.0/24"
# vpc_cidr_private_AZa: "10.64.18.0/26"
# vpc_cidr_private_AZb: "10.64.18.64/26"
# vpc_cidr_private_AZc: "10.64.18.128/26"
# vpc_cidr_prublic: "10.64.19.0/24"
# vpc_cidr_public_AZa: "10.64.19.0/26"
# vpc_cidr_public_AZb: "10.64.19.64/26"
# vpc_cidr_public_AZc: "10.64.19.128/26"
