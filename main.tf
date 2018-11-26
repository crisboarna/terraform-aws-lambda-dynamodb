#required otherwise circular dependency between IAM and Lambda
locals {
  lambda_function_name              = "${var.project}-${var.lambda_function_name}-${terraform.workspace}"
  dynamodb_tables_count             = "${length(var.dynamodb_table_properties)}"
}

module "lambda" {
  source                            = "./modules/services/lambda"

  #Setup
  region                            = "${var.region}"
  lambda_function_name              = "${local.lambda_function_name}"
  lambda_description                = "${var.lambda_description}"
  lambda_runtime                    = "${var.lambda_runtime}"
  lambda_handler                    = "${var.lambda_handler}"
  lambda_timeout                    = "${var.lambda_timeout}"
  lambda_file_name                  = "${var.lambda_file_name}"
  lambda_code_s3_bucket_existing    = "${var.lambda_code_s3_bucket_existing}"
  lambda_code_s3_bucket_new         = "${var.lambda_code_s3_bucket_new}"
  lambda_code_s3_bucket_use_existing = "${var.lambda_code_s3_bucket_use_existing}"
  lambda_code_s3_key                = "${var.lambda_code_s3_key}"
  lambda_code_s3_storage_class      = "${var.lambda_code_s3_storage_class}"
  lambda_code_s3_bucket_visibility  = "${var.lambda_code_s3_bucket_visibility}"
  lambda_zip_path                   = "${var.lambda_zip_path}"
  lambda_memory_size                = "${var.lambda_memory_size}"

  #Internal
  lambda_role                       = "${module.iam.lambda_role_arn}"

  #Environment variables
  environment_variables             = "${var.environment_variables}"

  #Tags
  tags                              = "${var.tags}"
}

module "dynamodb" {
  source                            = "./modules/services/dynamodb"

  #Setup
  dynamodb_table_properties         = "${var.dynamodb_table_properties}"
  dynamodb_table_attributes         = "${var.dynamodb_table_attributes}"
  dynamodb_table_secondary_index    = "${var.dynamodb_table_secondary_index}"

  #Tags
  tags                              = "${var.tags}"
}

module "iam" {
  source                            = "./modules/global/iam"

  #Setup
  lambda_name                       = "${local.lambda_function_name}"
  dynamodb_arn_list                 = "${module.dynamodb.dynamodb_table_arns}"
  dynamodb_policy_action_list       = "${var.dynamodb_policy_action_list}"
  dynamodb_tables_count             = "${local.dynamodb_tables_count}"
}