variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "status_checker"
}

variable "lambda_filename" {
  description = "Path to the Lambda deployment package zip file"
  type        = string
  default     = "../dist/example_lambda.zip"
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "Lambda runtime version"
  type        = string
  default     = "python3.11"
}

variable "lambda_role_name" {
  description = "IAM role name for Lambda"
  type        = string
  default     = "lambda_exec_role"
}

variable "lambda_policy_name" {
  description = "IAM policy name for Lambda"
  type        = string
  default     = "lambda_policy"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "security_group_name" {
  description = "Name of the security group for Lambda"
  type        = string
  default     = "lambda_sg"
}

variable "secret_name" {
  description = "Name of the secret in Secrets Manager"
  type        = string
  default     = "lambda_secret"
}

variable "kms_key_description" {
  description = "Description for the KMS key"
  type        = string
  default     = "KMS key for Lambda encryption"
}

variable "kms_deletion_window_in_days" {
  description = "KMS key deletion window in days"
  type        = number
  default     = 10
}

variable "resource_name_tag" {
  description = "Value for the Name tag on all resources"
  type        = string
  default     = "TESTAPP"
}

# variable "kms_key_policy" {
#   description = "KMS key policy JSON"
#   type        = string
# }
