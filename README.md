# Terraform AWS Lambda DynamoDB

### Terraform module for AWS Lambda DynamoDB infrastructure
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)
![stability-stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)
![Commitizen-friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)
## Table of Contents
* [Features](#features)
* [Usage](#usage)
* [Deployment](#deployment)
* [Example](#example)

## Features
Terraform module which deploys Lambda & DynamoDB to be used as building block. 

***Attention***

Starting from version 1.4.0, this module targets Terraform 0.12+. If you are using Terraform <=v0.11 you must use up to version 1.3.0.

**Lambda**

This module is created with full customization by user.
- Can use either local filename path `lambda_file_name` or remote S3 bucket configuration.
- Supports Lambda Layers
- Supports VPC


**Must** use either the local filename or S3 option as they are mutually exclusive. 
Exports S3 bucket to allow usage by multiple Lambda's but given `lambda_code_s3_bucket_use_existing=true` it will use existing S3 bucket provided in `lambda_code_s3_bucket_existing`.
- This module by default, if created allows accompanying Lambda access to `dynamodb:PutItem`, `dynamodb:DescribeTable`, `dynamodb:DeleteItem`, `dynamodb:GetItem`, `dynamodb:Scan`, `dynamodb:Query` all DynamoDB tables.


**DynamoDB**

This module is optional. Lambda is created with R/W permission for DynamoDB to allow Lambda creation of tables or optionally to create them before-hand with this script.
- This module by default, if created allows accompanying Lambda access to `dynamodb:PutItem`, `dynamodb:DescribeTable`, `dynamodb:DeleteItem`, `dynamodb:GetItem`, `dynamodb:Scan`, `dynamodb:Query` all DynamoDB tables.

**NOTE**

The attributes and table properties are in separate lists due to current HCL language parser limitations. Will update to single cohesive object once situation improves.
## Usage
```hcl-terraform
module "lambda-dynamodb" {
  source  = "crisboarna/lambda-dynamodb/aws"
  version = "1.4.0"

  # insert the required variables here
}
```

## Deployment
1. Run build process to generate Lambda ZIP file locally to match `lambda_zip_path` variable path
2. Provide all needed variables from `variables.tf` file or copy paste and change example below
3. Create/Select Terraform workspace before deployment
4. Run `terraform plan -var-file="<.tfvars file>` to check for any errors and see what will be built
5. Run `terraform apply -var-file="<.tfvars file>` to deploy infrastructure

**Example Deployment Script**
```sh
#!/usr/bin/env bash

if [[ ! -d .terraform ]]; then
  terraform init
fi
if ! terraform workspace list 2>&1 | grep -qi "$ENVIRONMENT"; then
  terraform workspace new "$ENVIRONMENT"
fi
terraform workspace select "$ENVIRONMENT"
terraform get
terraform plan -var-file=$1
terraform apply -var-file=$1
```

## Example
```hcl-terraform
module "lambda_dynamodb" {
  source  = "crisboarna/lambda-dynamodb"
  version = "v1.4.0"

  #Global
  region = "eu-west-1"
  project = "Awesome Project"
   
  #Lambda
  lambda_function_name = "Awesome Endpoint"
  lambda_description = "Awesome HTTP Endpoint Lambda"
  lambda_runtime = "nodejs8.10"
  lambda_handler = "dist/bin/lambda.handler"
  lambda_timeout = 30
  lambda_code_s3_bucket = "awesome-project-bucket"
  lambda_code_s3_key = "awesome-project.zip"
  lambda_code_s3_storage_class = "ONEZONE_IA"
  lambda_code_s3_bucket_visibility = "private"
  lambda_zip_path = "../../awesome-project.zip"
  lambda_memory_size = 256
  lambda_vpc_security_group_ids = [aws_security_group.vpc_security_group.id]
  lambda_vpc_subnet_ids = [aws_subnet.vpc_subnet_a.id]
  lambda_layers = [data.aws_lambda_layer_version.layer.arn]

  #DynamoDB
  dynamodb_table_properties = [
    { 
      name = "Awesome Project Table 1"
    },
    {
      name = "Awesome Project Table 2",
      read_capacity = 2,
      write_capacity = 3,
      hash_key = "KEY"
      range_key = ""
      stream_enabled = "true"
      stream_view_type = "NEW_IMAGE"
    }
  ]
  
  dynamodb_table_attributes = [[
    {
      name = "KEY"
      type = "S"
    }],[
    {
      name = "PRIMARY_KEY"
      type = "N"
    }, {
      name = "SECONDARY_KEY"
      type = "S"
    }
   ]]
   
   dynamodb_table_secondary_index = [[
    {
      name               = "GameTitleIndex"
      hash_key           = "GameTitle"
      range_key          = "TopScore"
      write_capacity     = 10
      read_capacity      = 10
      projection_type    = "INCLUDE"
      non_key_attributes = ["UserId"]
    }
   ]]
   
   dynamodb_policy_action_list = ["dynamodb:PutItem", "dynamodb:DescribeTable", "dynamodb:DeleteItem", "dynamodb:GetItem", "dynamodb:Scan", "dynamodb:Query"]
   dynamodb_table_ttl = [[
      {
        attribute_name = "ttl"
        enabled = true
      }
   ]]
       
  #Tags
  tags = {
    project = "Awesome Project"
    managedby = "Terraform"
  }
  
  #Lambda Environment variables
  environment_variables = {
    NODE_ENV = "production"
  }
}
```