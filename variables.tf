#TAGS
variable "tags" {
  type = "map"
  description = "Tags for lambda"
  default = {}
}


#Environment variables
variable "environment_variables" {
  type = "map"
  description = "Environment variables"
}


#SETUP

#Global
variable "region" {
  description = "Region to deploy in"
}

variable "project" {
  description = "Name of project"
}

#Lambda
variable "lambda_function_name" {
  description = "Local path to Lambda zip code"
}

variable "lambda_description" {
  default = ""
  description = "Lambda description"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
}

variable "lambda_handler" {
  description = "Lambda handler path"
}

variable "lambda_timeout" {
  description = "Maximum runtime for Lambda"
  default = 30
}

variable "lambda_file_name" {
  default = "defaultLambdaFile.zip"
  description = "Path to lambda code zip"
}

variable "lambda_code_s3_bucket_new" {
  default = "defaultBucket"
  description = "S3 bucket with source code"
}

variable "lambda_code_s3_bucket_use_existing" {
  default = "true"
  description = "Boolean flag to specify whether to use 'lambda_code_s3_bucket_new' and create new bucket or to use 'lambda_code_s3_bucket_existing and use existing S3 bucket and now a generate new one"
}

variable "lambda_code_s3_bucket_existing" {
  default = "defaultBucket"
  description = "Existing 'aws_s3_bucket.bucket'"
}

variable "lambda_code_s3_key" {
  default = "defaultS3Key"
  description = "Location of Lambda code in S3 bucket"
}

variable "lambda_code_s3_storage_class" {
  description = "Lambda code S3 storage class"
  default = "ONEZONE_IA"
}

variable "lambda_code_s3_bucket_visibility" {
  default = "private"
  description = "S3 bucket ACL"
}

variable "lambda_zip_path" {
  default = "defaultZipPath"
  description = "Local path to Lambda zip code"
}

variable "lambda_memory_size" {
  description = "Lambda memory size"
}

variable "lambda_vpc_security_group_ids" {
  description = "Lambda VPC Security Group IDs"
  type = list(string)
  default = []
}

variable "lambda_vpc_subnet_ids" {
  description = "Lambda VPC Subnet IDs"
  type = list(string)
  default = []
}

variable "lambda_layers" {
  description = "Lambda Layer ARNS"
  type = list(string)
  default = []
}

#DynamoDB
variable "dynamodb_table_properties" {
  type = "list"
  description = "List of maps representing a table each. name (required), read_capacity(default=1), write_capacity(default=1), hash_key(required)"
}

variable "dynamodb_table_attributes" {
  type = "list"
  description = "List of list of maps representing each table attributes list. Required due to current HCL limitations"
}

variable "dynamodb_table_secondary_index" {
  type = "list"
  default = [[]]
  description = "List of list of maps representing each table secondary index list. Required due to current HCL limitations"
}

variable "dynamodb_policy_action_list" {
  description = "List of Actions to be executed"
  type = "list"
  default = ["dynamodb:DescribeTable", "dynamodb:DeleteItem", "dynamodb:GetItem", "dynamodb:Scan", "dynamodb:Query"]
}

variable "dynamodb_table_ttl" {
  type = "list"
  default = [[]]
  description = "List of list of maps representing each table local secondary index list. Required due to current HCL limitations"
}