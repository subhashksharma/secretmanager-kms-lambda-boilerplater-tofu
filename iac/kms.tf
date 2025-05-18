# KMS Key for Lambda encryption
resource "aws_kms_key" "lambda_key" {
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_deletion_window_in_days
  policy = templatefile("${path.module}/policies/kms_key_policy.json", {
    account_id      = data.aws_caller_identity.current.account_id
    lambda_role_arn = aws_iam_role.lambda_exec.arn
  })
  tags = {
    Name = var.resource_name_tag
  }
  depends_on = [aws_iam_role.lambda_exec]
}
