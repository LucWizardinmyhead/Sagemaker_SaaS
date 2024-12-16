provider "aws" {
  region = var.aws_region
}

locals {
  stack_name = "root-stack-template"
  stack_id = uuidv5("dns", "root-stack-template")
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

###########
###VPC#####
###########

module "networking" {
  source = "./modules/networking"
  
  env        = var.env
  aws_region = var.aws_region
}

#########
###IAM###
#########

resource "aws_iam_role" "auth_role" {
  name = var.auth_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"  # Change to "Allow" if you want authenticated users to assume this role
        Principal = {
          Federated = "cognito-identity-us-gov.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "cognito-identity.us-gov.amazonaws.com:sub" = aws_cognito_identity_pool.identity_pool.id
          }
      }}
    ]
  })
}

resource "aws_iam_role" "unauth_role" {
  name = var.unauth_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "cognito-identity-us-gov.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "cognito-identity.us-gov.amazonaws.com:sub" = aws_cognito_user_pool_client.user_pool_client.id 
          }
      }}
    ]
  })
}

# IAM Role for Lambda Functions
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

##############
###COGNITO####
#######

resource "aws_cognito_user_pool" "user_pool" {
  name = "gov_cloud_dev_user_pool"

  alias_attributes = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
  }

  mfa_configuration = "OFF"  # Change to "ON" or "OPTIONAL" as needed

  tags = {
    Name = "gov-cloud-dev"
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "gov_cloud_dev_user_pool_client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  read_attributes  = ["email"]
  write_attributes = ["email"]
}

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name = "gov_cloud_dev_identity_pool"
  allow_unauthenticated_identities = true  # Set to false if you don't want unauthenticated access

  cognito_identity_providers {
    provider_name = aws_cognito_user_pool.user_pool.endpoint
    client_id     = aws_cognito_user_pool_client.user_pool_client.id
  }
}


########
###API###
########

module "api" {
  source = "./modules/api"

  AWSRegion = var.aws_region
  env       = var.env

  # Pass the Lambda function ARNs to the API module
  functionDocManagementArn = aws_lambda_function.doc_management.arn
  functionDocRoutingArn    = aws_lambda_function.doc_routing.arn
  functionIndepthArn       = aws_lambda_function.indepth.arn
  functionLLMArn           = aws_lambda_function.llm.arn
  functionPastMapperArn    = aws_lambda_function.past_mapper.arn
  functionPullDocumentArn   = aws_lambda_function.pull_document.arn
  functionReturnInfoArn     = aws_lambda_function.return_info.arn
  functionSAMDetailedArn     = aws_lambda_function.sam_detailed.arn
  functionSAMFinderArn       = aws_lambda_function.sam_finder.arn
  functionSAMMapperArn       = aws_lambda_function.sam_mapper.arn

  data_flow = var.data_flow
}

##########
###AUTH###
##########

module "auth" {
  source = "./modules/auth"
  data_flow         = var.data_flow  
  auth_role_name    = var.auth_role_name  
  unauth_role_name  = var.unauth_role_name  
  env = var.env
}

##########
###S3#####
##########  

resource "aws_s3_bucket" "deployment_bucket" {
  bucket = var.deployment_bucket_name
}

resource "aws_s3_bucket_policy" "deployment_bucket_policy" {
bucket = aws_s3_bucket.deployment_bucket.id  # Correct reference
policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Action = "s3:*"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws-us-gov:iam::271945552223:role/${var.lambda_exec_role}"
      }
      Resource = [
        "${aws_s3_bucket.deployment_bucket.arn}/*",
        aws_s3_bucket.deployment_bucket.arn
      ]
      Condition = {
        Bool = {
          "aws:SecureTransport" = true
        }
      }
    }
  ]
 })
}

###########
###DB#####
###########

module "database" {
  source = "./modules/database"

  env                = var.env
  aws_region         = var.aws_region
  db_instance_class   = var.db_instance_class
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  db_allocated_storage = var.db_allocated_storage
}

##########
###ECS#####
##########

module "ecs" {
  source = "./modules/ecs"

  cluster_name        = var.cluster_name  
  #capacity_providers  = var.capacity_providers  # Need to figure out how yto add fargate and fargate spot
}

# module "sagemaker" {
#   source = "./modules/sagemaker"
# }

# resource "aws_lambda_function" "update_roles_with_idp_function" {
#   code_signing_config_arn = {
#     ZipFile = <<-EOF
#       const response = require('cfn-response');
#       const { IAMClient, GetRoleCommand, UpdateAssumeRolePolicyCommand } = require('@aws-sdk/client-iam');
      
#       exports.handler = function(event, context) {
#           // Don't return promise, response.send() marks context as done internally
#           const ignoredPromise = handleEvent(event, context)
#       };
      
#       // ... rest of your Lambda function code ...
#     EOF
#   }
#   handler = "index.handler"
#   role = aws_iam_role.update_roles_with_idp_function_role.arn
#   runtime = "nodejs18.x"
#   timeout = 300
# }

# resource "aws_bedrock_custom_model" "update_roles_with_idp_function_outputs" {
#   // CF Property(ServiceToken) = aws_lambda_function.update_roles_with_idp_function.arn
#   custom_model_name = aws_iam_role.unauth_role.arn
#   // CF Property(idpId) = aws_cloudformation_stack.authturnkey49093406.outputs.IdentityPoolId
#   // CF Property(region) = data.aws_region.current.name
# }

# resource "aws_iam_role" "update_roles_with_idp_function_role" {
#   assume_role_policy = {
#     Statement = [
#       {
#         Action = [
#           "sts:AssumeRole"
#         ]
#         Effect = "Allow"
#         Principal = {
#           Service = [
#             "lambda.amazonaws.com"
#           ]
#         }
#       }
#     ]
#     Version = "2012-10-17"
#   }
#   force_detach_policies = [
#     {
#       PolicyDocument = {
#         Statement = [
#           {
#             Action = [
#               "logs:CreateLogGroup",
#               "logs:CreateLogStream",
#               "logs:PutLogEvents"
#             ]
#             Effect = "Allow"
#             Resource = "arn:aws-us-gov:logs:*:*:*"
#           },
#           {
#             Action = [
#               "iam:UpdateAssumeRolePolicy",
#               "iam:GetRole"
#             ]
#             Effect = "Allow"
#             Resource = aws_iam_role.auth_role.arn
#           },
#           {
#             Action = [
#               "iam:UpdateAssumeRolePolicy",
#               "iam:GetRole"
#             ]
#             Effect = "Allow"
#             Resource = aws_iam_role.unauth_role.arn
#           }
#         ]
#         Version = "2012-10-17"
#       }
#       PolicyName = "UpdateRolesWithIDPFunctionPolicy"
#     }
#   ]
#   name = join("", [aws_iam_role.auth_role.arn, "-idp"])
# }

resource "aws_lambda_function" "doc_management" {
  function_name = "DocManagement"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "271945552223.dkr.ecr.us-gov-west-1.amazonaws.com/docmanagement:latest"
  package_type = "Image" 
}

resource "aws_lambda_function" "doc_routing" {
  function_name = "DocRouting"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "271945552223.dkr.ecr.us-gov-west-1.amazonaws.com/docrouting:latest"
  package_type = "Image"
}

resource "aws_lambda_function" "indepth" {
  function_name = "Indepth"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "271945552223.dkr.ecr.us-gov-west-1.amazonaws.com/indepth:latest"
  package_type = "Image"
}

resource "aws_lambda_function" "llm" {
  function_name = "LLM"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "271945552223.dkr.ecr.us-gov-west-1.amazonaws.com/llm:latest"
  package_type = "Image"
}

resource "aws_lambda_function" "past_mapper" {
  function_name = "PastMapper"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "271945552223.dkr.ecr.us-gov-west-1.amazonaws.com/pastmapper:latest"
  package_type = "Image"
}

resource "aws_lambda_function" "pull_document" {
  function_name = "PullDocument"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "271945552223.dkr.ecr.us-gov-west-1.amazonaws.com/pulldocument:latest"
  package_type = "Image"
}

resource "aws_lambda_function" "return_info" {
  function_name = "ReturnInfo"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "271945552223.dkr.ecr.us-gov-west-1.amazonaws.com/returninfo:latest"
  package_type = "Image"
}

resource "aws_lambda_function" "sam_detailed" {
  function_name = "SAMDetailed"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "271945552223.dkr.ecr.us-gov-west-1.amazonaws.com/samdetailed:latest"
  package_type = "Image"
}

resource "aws_lambda_function" "sam_finder" {
  function_name = "SAMFinder"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "271945552223.dkr.ecr.us-gov-west-1.amazonaws.com/samfinder:latest"
  package_type = "Image"
}

resource "aws_lambda_function" "sam_gatherer" {
  function_name = "SAMGatherer"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "271945552223.dkr.ecr.us-gov-west-1.amazonaws.com/samgatherer:latest"
  package_type = "Image"
}

resource "aws_lambda_function" "sam_mapper" {
  function_name = "SAMMapper"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = "271945552223.dkr.ecr.us-gov-west-1.amazonaws.com/sammapper:latest"
  package_type = "Image"
}