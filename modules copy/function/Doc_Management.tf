data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  ShouldNotCreateEnvResources = var.env == "NONE"
}

variable region {
  description = "GovCloud regions"
  type = string
  default = data.aws_region.current.name
}

variable cloud_watch_rule {
  description = "Schedule Expression"
  type = string
  default = "NONE"
}

variable lambda_layer_arn {
  description = "ARN of the Lambda Layer"
  type = string
}

variable deployment_bucket_name {
  description = "Name of the deployment bucket"
  type = string
}

variable env {
  description = "Environment name"
  type = string
  default = "govcloud-dev"
}

variable s3_key {
  description = "S3 key for Lambda function code"
  type = string
}

resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  }
  name = local.ShouldNotCreateEnvResources ? "turnkeyLambdaRole276aa5fd" : join("", ["turnkeyLambdaRole276aa5fd", "-", var.env])
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
  function_name = local.ShouldNotCreateEnvResources ? "DocManagement" : join("", ["DocManagement", "-", var.env])
  handler = "index.handler"
  layers = [
    var.lambda_layer_arn
  ]
  role = aws_iam_role.lambda_execution_role.arn
  runtime = "python3.8"
  timeout = 25
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
      }
    ]
  }
  // CF Property(Roles) = [
  //   aws_iam_role.lambda_execution_role.arn
  // ]
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

output "name" {
  value = aws_lambda_function.lambda_function.arn
}

output "region" {
  value = data.aws_region.current.name
}

output "lambda_execution_role" {
  value = aws_iam_role.lambda_execution_role.arn
}

output "region" {
  value = data.aws_region.current.name
}

output "lambda_execution_role" {
  value = aws_iam_role.lambda_execution_role.arn
}


output "lambda_execution_role" {
  value = aws_iam_role.lambda_execution_role.arn
}
output "lambda_execution_role" {
  value = aws_iam_role.lambda_execution_role.arn
}


output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}