locals {
  service = "lambda_appsync"
}

module "dynamodb" {
  source       = "../../modules/dynamodb"
  product_name = "${var.env}-${local.service}"
}

module "appsync" {
  source              = "../../modules/appsync"
  product_name        = "${var.env}_${local.service}"
  dynamodb_arn        = module.dynamodb.dynamodb_arn
  dynamodb_table_name = module.dynamodb.dynamodb_table_name
}

module "lambda" {
  source           = "../../modules/lambda"
  function_name    = "${var.env}-${local.service}"
  appsync_endpoint = module.appsync.appsync_endpoint
}
