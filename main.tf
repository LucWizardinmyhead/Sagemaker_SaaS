provider "aws" {
  region = var.aws_region
}

locals {
  stack_name = "root-stack-template"
  stack_id = uuidv5("dns", "root-stack-template")
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

variable "aws_region" {
  description = "The AWS region to deploy resources to"
  type        = string
  default     = "us-west-1"  # You can change this default value as needed
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of AZs to use"
  type        = number
  default     = 2
}

variable "env_name" {
  description = "Environment name"
  type        = string
}

###########
###VPC#####
###########

module "networking" {
  source = "./modules/networking"
  
  # Required arguments
  env           = var.env
  aws_region    = var.aws_region
  vpc_cidr      = var.vpc_cidr
  azs           = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]  # Matches pub_subnets requirement
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"] # Matches priv_subnets
  
  # Optional arguments
  multi_az      = true
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
        Effect = "Allow"
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:sub" = aws_cognito_identity_pool.identity_pool.id
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
          Federated = "cognito-identity.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:sub" = aws_cognito_user_pool_client.user_pool_client.id
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
  name = "cloud_dev_user_pool"

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
    Name = "cloud-dev"
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "cloud_dev_user_pool_client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  read_attributes  = ["email"]
  write_attributes = ["email"]
}

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name = "cloud_dev_identity_pool"
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
  bucket = "terraform-config-dev-west-1-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_policy" "deployment_bucket_policy" {
  bucket = aws_s3_bucket.deployment_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.lambda_exec_role}"
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
### RDS ###
###########
# 1. First define the security group
resource "aws_security_group" "rds_sg" {
  name        = "${var.env}-rds-sg"
  description = "Security group for RDS access"
  vpc_id      = module.networking.vpc_id
  
  ingress {
    from_port   = 5432  # Change to 3306 for MySQL
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Then define the subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.env}-rds-subnet-group"
  subnet_ids = module.networking.private_subnet_ids

  tags = {
    Name = "${var.env}-rds-subnet-group"
  }
}

# 3. Now call the database module with the references
module "database" {
  source = "./modules/database"

  env                  = var.env
  aws_region           = var.aws_region
  db_instance_class    = var.db_instance_class
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_allocated_storage = var.db_allocated_storage
  
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
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

