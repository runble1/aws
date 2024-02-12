resource "aws_s3_bucket" "app" {
  bucket        = "${var.product}-app-access-log-${data.aws_caller_identity.self.account_id}"
  force_destroy = true
}
