# IAM Role and Policies for Lambda
resource "aws_iam_role" "lambda_exec" {
  name               = var.lambda_role_name
  assume_role_policy = file("${path.module}/policies/lambda_assume_role.json")
  tags = {
    Name = var.resource_name_tag
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = var.lambda_policy_name
  role   = aws_iam_role.lambda_exec.id
  policy = file("${path.module}/policies/lambda_policy.json")
}
