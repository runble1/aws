resource "aws_cognito_user_pool" "google" {
  name                     = "${var.function_name}-user-pool-google"
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_domain" "google" {
  domain       = "${var.function_name}-domain-google"
  user_pool_id = aws_cognito_user_pool.google.id
}

resource "aws_cognito_user_pool_client" "google" {
  name = "${var.function_name}-client-google"
  user_pool_id = aws_cognito_user_pool.google.id

  callback_urls = ["http://localhost:3000/api/auth/callback/cognito"]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = ["code", "implicit"]
  allowed_oauth_scopes = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]

  generate_secret = true

  explicit_auth_flows = [
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]

  prevent_user_existence_errors = "ENABLED" # ユーザ存在エラーを防ぐ

  //read_attributes  = ["email", "custom:custom_attribute"]
  //write_attributes = ["email", "custom:custom_attribute"]
}

# Google 認証用
resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.google.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    client_id     = "1016772177424-k8omndbef87ebdlfpmrjfp2qhtm28767.apps.googleusercontent.com"
    client_secret = "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"
    authorize_scopes = "email"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

