data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  ShouldNotCreateEnvResources = var.env == "NONE"
}

resource "aws_iam_policy" "policy_apigw_auth1" {
  name        = "APIGatewayAuthPolicy"  # Add a name for the policy
  description = "Policy for API Gateway authentication"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "execute-api:Invoke"
        ]
        Effect = "Allow"
        Resource = [
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/PastMapper/*"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/PastMapper"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/DocRouting/*"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/DocRouting"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/SAMFinder/*"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/SAMFinder"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/SAMMapper/*"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/SAMMapper"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/ReturnInfo/*"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/ReturnInfo"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/DocManagement/*"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/DocManagement"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/LLM/*"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/LLM"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/Indepth/*"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/Indepth"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/SAMDetailed/*"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/SAMDetailed"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/PullDocument/*"]),
          join("", ["arn:aws-us-gov:execute-api:", data.aws_region.current.name, ":", data.aws_caller_identity.current.account_id, ":", var.data_flow, "/", local.ShouldNotCreateEnvResources ? "Prod" : var.env, "/*/PullDocument"])
        ]
      }
    ]
  })
}