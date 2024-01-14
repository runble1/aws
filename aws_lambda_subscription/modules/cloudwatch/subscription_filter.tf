resource "aws_cloudwatch_log_subscription_filter" "test_subscription_filter" {
  depends_on      = [aws_kinesis_firehose_delivery_stream.this]
  name            = "test_subscription_filter"
  log_group_name  = aws_cloudwatch_log_group.lambda_log_group.name
  filter_pattern  = "OK"
  destination_arn = aws_kinesis_firehose_delivery_stream.this.arn
  role_arn        = aws_iam_role.firehose_role.arn
}
