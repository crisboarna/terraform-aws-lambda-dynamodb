#Lambda
output "lambda_name" {
  value = "${module.lambda.lambda_name}"
}

output "lambda_arn" {
  value = "${module.lambda.lambda_arn}"
}

output "lambda_role_id" {
  value = "${module.iam.lambda_role_id}"
}

output "lambda_role_arn" {
  value = "${module.iam.lambda_role_arn}"
}

output "lambda_role_name" {
  value = "${module.iam.lambda_role_name}"
}

output "lambda_s3_bucket" {
  value = "${module.lambda.lambda_s3_bucket}"
}

output "dynamodb_table_name" {
  value = "${module.dynamodb.dynamodb_table_names}"
}

output "dynamodb_table_hash_keys" {
  value = ["${module.dynamodb.dynamodb_table_hash_keys}"]
}

output "dynamodb_table_range_keys" {
  value = ["${module.dynamodb.dynamodb_table_range_keys}"]
}

output "dynamodb_table_arns" {
  value = ["${module.dynamodb.dynamodb_table_arns}"]
}

output "dynamodb_table_stream_arns" {
  value = ["${module.dynamodb.dynamodb_table_stream_arns}"]
}