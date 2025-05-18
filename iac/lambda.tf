# Lambda function with VPC, KMS, and Secret Manager
resource "aws_lambda_function" "status_checker" {
  function_name    = var.lambda_function_name
  filename         = var.lambda_filename
  source_code_hash = filebase64sha256(var.lambda_filename)
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  role             = aws_iam_role.lambda_exec.arn
  memory_size      = 512
  timeout           = 20
  vpc_config {
    subnet_ids         = [aws_subnet.lambda_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
  kms_key_arn = aws_kms_key.lambda_key.arn
  environment {
    variables = {
      SECRET_ARN = aws_secretsmanager_secret.lambda_secret.arn
    }
  }
  tags = {
    Name = var.resource_name_tag
  }
}
