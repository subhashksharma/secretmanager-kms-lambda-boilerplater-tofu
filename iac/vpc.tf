# VPC, Subnet, and Security Group
resource "aws_vpc" "lambda_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.resource_name_tag
  }
}

resource "aws_subnet" "lambda_subnet" {
  vpc_id            = aws_vpc.lambda_vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.resource_name_tag
  }
}

resource "aws_subnet" "lambda_subnet_b" {
  vpc_id            = aws_vpc.lambda_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.resource_name_tag
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.lambda_vpc.id

  tags = {
    Name = var.resource_name_tag
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.lambda_subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.lambda_subnet_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "lambda_sg" {
  name        = var.security_group_name
  description = "Allow outbound HTTPS for Lambda"
  vpc_id      = aws_vpc.lambda_vpc.id

  tags = {
    Name = var.resource_name_tag
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.lambda_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.lambda_subnet.id, aws_subnet.lambda_subnet_b.id]
  security_group_ids  = [aws_security_group.lambda_sg.id]
  private_dns_enabled = true
  tags = {
    Name = var.resource_name_tag
  }
}

resource "aws_vpc_endpoint" "kms" {
  vpc_id              = aws_vpc.lambda_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.kms"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.lambda_subnet.id, aws_subnet.lambda_subnet_b.id]
  security_group_ids  = [aws_security_group.lambda_sg.id]
  private_dns_enabled = true
  tags = {
    Name = var.resource_name_tag
  }
}

# resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
#   name = "/vpc/flowlogs"
#   retention_in_days = 7
# }

# resource "aws_vpc_flow_log" "lambda_subnet_flow_log" {
#   vpc_id = aws_vpc.lambda_vpc.id
#   traffic_type = "ALL"
#   log_group_name = aws_cloudwatch_log_group.vpc_flow_logs.name
#   iam_role_arn = aws_iam_role.lambda_exec.arn
# }