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

variable aws_access_key_id_sagemaker {
  type = string
}

variable aws_secret_access_key_sagemaker {
  type = string
}

variable bucket {
  type = string
}

variable cluster_name {
  type = string
}

variable db_host {
  type = string
}

variable db_region {
  type = string
}

variable deployment_bucket_name {
  type = string
}

variable endpoint_name_sagemaker {
  type = string
}

variable env {
  type = string
}

variable env_container_name {
  type = string
}

variable open_ai_key {
  type = string
}

variable region_name_sagemaker {
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

variable task_definition {
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
  name = local.ShouldNotCreateEnvResources ? "turnkeyLambdaRole904513b8" : join("", ["turnkeyLambdaRole904513b8", "-", var.env])
}

resource "aws_lambda_function" "lambda_function" {
  code_signing_config_arn = {
    S3Bucket = var.deployment_bucket_name
    S3Key = var.s3_key
  }
  environment {
    variables = {
      AWS_ACCESS_KEY_ID_SAGEMAKER = var.aws_access_key_id_sagemaker
      AWS_SECRET_ACCESS_KEY_SAGEMAKER = var.aws_secret_access_key_sagemaker
      BUCKET = var.bucket
      CLUSTER_NAME = var.cluster_name
      DB_HOST = var.db_host
      DB_REGION = var.db_region
      ENDPOINT_NAME_SAGEMAKER = var.endpoint_name_sagemaker
      ENV = var.env
      ENV_CONTAINER_NAME = var.env_container_name
      OPEN_AI_KEY = var.open_ai_key
      REGION = data.aws_region.current.name
      REGION_NAME_SAGEMAKER = var.region_name_sagemaker
      SECRET_NAME = var.secret_name
      SECRET_REGION = var.secret_region
      TASK_DEFINITION = var.task_definition
    }
  }
  function_name = local.ShouldNotCreateEnvResources ? "DocRouting" : join("", ["DocRouting", "-", var.env])
  handler = "index.handler"
  layers = [
    "arn:aws-us-gov:lambda:us-gov-east-1:271945552223:layer:pg8000:1"
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