#  # create s3 bucket for cost report to be exported to
#  
#  data "aws_s3_bucket" "cur_bucket_stockholm" {
#  	provider = aws.stockholm
#  	bucket = "tv2dkathenabillingcur"
#  }
#  #resource "aws_s3_bucket" "cur_bucket_stockholm" {
#  #	provider = aws.stockholm
#  #	bucket = "tv2dkathenabillingcur"
#  #}
#  #output "CURBucketInfoStockholm" {
#  #	value = aws_s3_bucket.cur_bucket_stockholm
#  #}
#  #
#  
#  ## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cur_report_definition.html
resource "aws_cur_report_definition" "sbx_cur_report" {
#  provider = aws.stockholm
  report_name                = "tv2-sbx-athena-billing-cur"
  time_unit                  = "HOURLY"

  # Athena
  format                     = "Parquet"
  compression                = "Parquet"

  # Default Test
  #format                     = "textORcsv"
  #compression                = "GZIP"

  additional_schema_elements = ["RESOURCES"]
  #additional_schema_elements = ["RESOURCES", "SPLIT_COST_ALLOCATION_DATA"]
  #s3_bucket = data.aws_s3_bucket.cur_bucket_stockholm.bucket
  s3_bucket = "tv2-sbx-billing-data-exports"
  #s3_bucket = aws_s3_bucket.cur_bucket_stockholm.bucket
  #s3_bucket = "tv2dkathenabillingcur"
  #s3_region = data.aws_s3_bucket.cur_bucket_stockholm.region
  #s3_region = aws_s3_bucket.cur_bucket_stockholm.region
  #s3_region = "eu-north-1"
  s3_region = "eu-central-1"
  #s3_prefix = "tv2dkathenabillingcur"
  s3_prefix = "BillingData"

  # Athena
  additional_artifacts       = ["ATHENA"]
  report_versioning = "OVERWRITE_REPORT"

  # Default Test
  #additional_artifacts       = ["REDSHIFT", "QUICKSIGHT"]

  refresh_closed_reports     = false
}
import {
  to = aws_cur_report_definition.sbx_cur_report
  id = "tv2-sbx-athena-billing-cur"
}
#  
#  # Resource was already created
#  #data "aws_cur_report_definition" "prod_cur_report" {
#  #  report_name = "TV2DKAthenaBillingCUR"
#  #}
#  #output "TV2DKAthenaBillingCUR" {
#  #	value = data.aws_cur_report_definition.prod_cur_report
#  #}
#  
#  # Data exports released in terraform 5.47.0 - aws_bcmdataexports_export
#  # - https://github.com/hashicorp/terraform-provider-aws/pull/36847
#  # - https://github.com/hashicorp/terraform-provider-aws/issues/35343
#  # - https://github.com/hashicorp/terraform-provider-aws/blob/v5.47.0/CHANGELOG.md
#  
#  #resource "aws_bcmdataexports_export" "test" {
#  #  export {
#  #    name = "testexample"
#  #    data_query {
#  #      query_statement = "SELECT identity_line_item_id, identity_time_interval, line_item_product_code,line_item_unblended_cost FROM COST_AND_USAGE_REPORT"
#  #      table_configurations = {
#  #        COST_AND_USAGE_REPORT = {
#  #          TIME_GRANULARITY                      = "HOURLY",
#  #          INCLUDE_RESOURCES                     = "FALSE",
#  #          INCLUDE_MANUAL_DISCOUNT_COMPATIBILITY = "FALSE",
#  #          INCLUDE_SPLIT_COST_ALLOCATION_DATA    = "FALSE",
#  #        }
#  #      }
#  #    }
#  #    destination_configurations {
#  #      s3_destination {
#  #        s3_bucket = aws_s3_bucket.data_exports_bucket.bucket
#  #        s3_prefix = aws_s3_bucket.data_exports_bucket.bucket_prefix
#  #        s3_region = aws_s3_bucket.data_exports_bucket.region
#  #        s3_output_configurations {
#  #          overwrite   = "OVERWRITE_REPORT"
#  #          format      = "TEXT_OR_CSV"
#  #          compression = "GZIP"
#  #          output_type = "CUSTOM"
#  #        }
#  #      }
#  #    }
#  #
#  #    refresh_cadence {
#  #      frequency = "SYNCHRONOUS"
#  #    }
#  #  }
#  #}
#  
#  # Athena
#  # run the Athena cloudformation to setup schema digestion etc.
#  # ATHENA INFO on COLUMNS in CUR REPORT TABLE: 
#  # - https://docs.aws.amazon.com/cur/latest/userguide/data-dictionary.html
#  
#  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack
#  # https://tv2dkathenabillingcur.s3.eu-north-1.amazonaws.com/tv2dkathenabillingcur/TV2DKAthenaBillingCUR/crawler-cfn.yml
#  # s3://tv2dkathenabillingcur/tv2dkathenabillingcur/TV2DKAthenaBillingCUR/crawler-cfn.yml
#  #resource "aws_cloudformation_stack" "athena_crawler" {
#  #       WAS ALREADY CREATED MANUALLY, so the code is left for later use
#  #	name = "Athena CUR Crawler"
#  #	template_url = "https://tv2dkathenabillingcur.s3.eu-north-1.amazonaws.com/tv2dkathenabillingcur/TV2DKAthenaBillingCUR/crawler-cfn.yml"
#  #	capabilities  = [CAPABILITY_IAM]
#  #}
#  
#  # Athena - Pre
#  # - Make S3 bucket for Athena query results
#  # - configure Athena to know this bucket
#  resource "aws_s3_bucket" "athena_billing_output_bucket" {
#  	provider = aws.stockholm
#  	bucket = "tv2-athena-billing-outputs"
#  	tags = {
#  		CreatedBy = "aft account customization pipeline for aws-ct-mgmt"
#  		Name = "tv2-athena-outputs"
#  		Usage = "Bucket to hold query results from Athena"
#  	}
#  }
#  resource "aws_s3_bucket_server_side_encryption_configuration" "ensure_encryption_on_bucket" {
#    bucket = aws_s3_bucket.athena_billing_output_bucket.id
#  
#    rule {
#      apply_server_side_encryption_by_default {
#        sse_algorithm     = "AES256"
#      }
#    }
#  }
#  
#  locals {
#  	athena_cur_workgroup_name = "billing"
#  	athena_cur_database_name = "athenacurcfn_t_v2_d_k_athena_billing_c_u_r"
#  }
#  
#  resource "aws_athena_workgroup" "billing" {
#    name = local.athena_cur_workgroup_name
#  
#    configuration {
#      enforce_workgroup_configuration    = true
#      publish_cloudwatch_metrics_enabled = true
#  
#      result_configuration {
#        output_location = "s3://${aws_s3_bucket.athena_billing_output_bucket.bucket}/"
#  
#        encryption_configuration {
#          encryption_option = "SSE_S3"
#        }
#      }
#    }
#  }
#  
#  # An Athena query
#  resource "aws_athena_named_query" "athena_status" {
#    name      = "athena status"
#    workgroup = local.athena_cur_workgroup_name
#    database  = local.athena_cur_database_name
#  //  query     = "SELECT * FROM ${aws_athena_database.athenacur.name} limit 10;"
#    description = "check the status"
#    query     = "SELECT status FROM cost_and_usage_data_status limit 10;"
#  }
#  
#  
#  
