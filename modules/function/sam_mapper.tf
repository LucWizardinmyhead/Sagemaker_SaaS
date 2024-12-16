data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  ShouldNotCreateEnvResources = var.env == "NONE"
}

variable cloud_watch_rule {
  description = " Schedule Expression"
  type = string
  default = "NONE"
}

variable deployment_bucket_name {
  type = string
}

variable env {
  type = string
}

variable s3_key {
  type = string
}

resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = {
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com"
          ]
        }
      }
    ]
    Version = "2012-10-17"
  }
  name = local.ShouldNotCreateEnvResources ? "turnkeyLambdaRole8a23de80" : join("", ["turnkeyLambdaRole8a23de80", "-", var.env])
}

resource "aws_lambda_function" "lambda_function" {
  code_signing_config_arn = {
    S3Bucket = var.deployment_bucket_name
    S3Key = var.s3_key
  }
  environment {
    variables = {
      ENV = var.env
      REGION = data.aws_region.current.name
    }
  }
  function_name = local.ShouldNotCreateEnvResources ? "SAMMapper" : join("", ["SAMMapper", "-", var.env])
  handler = "index.handler"
  layers = [
  ]
  role = aws_iam_role.lambda_execution_role.arn
  runtime = "python3.8"
  timeout = 25
}

resource "aws_iam_policy" "lambdaexecutionpolicy" {
  policy = {
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "arn:aws:logs:us-gov-east-2:271945552223:log-group:/aws/lambda/${aws_lambda_function.lambda_function.arn}:log-stream:*"
      }
    ]
    Version = "2012-10-17"
  }
  name = "lambda-execution-policy"
  // CF Property(Roles) = [
  //   aws_iam_role.lambda_execution_role.arn
  // ]
}

output "arn" {
  value = aws_lambda_function.lambda_function.arn
}

output "lambda_execution_role" {
  value = aws_iam_role.lambda_execution_role.arn
}

output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}

output "name" {
  value = aws_lambda_function.lambda_function.arn
}

output "region" {
  value = data.aws_region.current.name
}