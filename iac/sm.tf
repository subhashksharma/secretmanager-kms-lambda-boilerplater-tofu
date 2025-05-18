# Secret Manager secret encrypted with KMS
resource "aws_secretsmanager_secret" "lambda_secret" {
  name       = var.secret_name
  kms_key_id = aws_kms_key.lambda_key.arn
  tags = {
    Name = var.resource_name_tag
  }
}

resource "aws_secretsmanager_secret_version" "lambda_secret_value" {
  secret_id     = aws_secretsmanager_secret.lambda_secret.id
  secret_string = jsonencode({ value = "test" })
}
