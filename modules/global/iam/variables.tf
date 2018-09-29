variable "lambda_name" {
  description = "The name of the Lambda function"
}

variable "dynamodb_arn_list" {
  type = "list"
  description = "List of ARN's to allow permissions for"
}

variable "dynamodb_policy_action_list" {
  type = "list"
  description = "List of ARN's to allow permissions for"
}

variable "dynamodb_tables_count" {
  description = "Number of tables being created"
}