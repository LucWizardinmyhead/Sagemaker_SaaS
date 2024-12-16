data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  ShouldNotCreateEnvResources = var.env == "NONE"
}

variable cloud_watch_rule {
  description = "Schedule Expression"
  type = string
  default = "NONE"
}

variable db_host {
  type = string
}

variable deployment_bucket_name {
  type = string
}

variable env {
  type = string
}

variable region {
  type = string
}

variable s3_key {
  type = string
}

variable secret_name {
  type = string
}

variable secret_region {
  type = string
}

resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com"
          ]
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  }
  name = local.ShouldNotCreateEnvResources ? "turnkeyLambdaRole1d2e7a76" : join("", ["turnkeyLambdaRole1d2e7a76", "-", var.env])
}

resource "aws_iam_policy" "lambdaexecutionpolicy" {
  name = "lambda-execution-policy"
  policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws-us-gov:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.lambda_function.arn}:log-stream:*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "arn:aws-us-gov:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.secret_name}-*"   
      }
    ]
  }
  // CF Property(Roles) = [
  //   aws_iam_role.lambda_execution_role.arn
  // ]
}

resource "aws_lambda_function" "lambda_function" {
  code_signing_config_arn = {
    S3Bucket = var.deployment_bucket_name
    S3Key = var.s3_key
  }
  environment {
    variables = {
      DB_HOST = var.db_host
      ENV = var.env
      REGION = var.region
      SECRET_NAME = var.secret_name
      SECRET_REGION = var.secret_region
    }
  }
  function_name = local.ShouldNotCreateEnvResources ? "PastMapper" : join("", ["PastMapper", "-", var.env])
  handler = "index.handler"
  layers = [
    "arn:aws-us-gov:lambda:us-gov-east-1:271945552223:layer:pg8000:1"
  ]
  role = aws_iam_role.lambda_execution_role.arn
  runtime = "python3.8"
  timeout = 25
}

output "arn" {
  value = aws_lambda_function.lambda_function.arn
}

output "name" {
  value = aws_lambda_function.lambda_function.arn
}

output "region" {
  value = data.aws_region.current.name
}

output "lambda_execution_role" {
  value = aws_iam_role.lambda_execution_role.arn
}

output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}