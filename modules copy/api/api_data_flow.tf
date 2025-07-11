provider "aws" {
  region = var.AWSRegion
}

data "aws_caller_identity" "current" {}

variable "AWSRegion" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-west-1"
  validation {
    condition     = contains(["us-east-1", "us-east-2"], var.AWSRegion)
    error_message = "Invalid AWS GovCloud region"
  }
}

variable "env" {
  description = "The deployment environment"
  type        = string
}

locals {
  should_not_create_env_resources = var.env == "NONE"
}

resource "aws_api_gateway_rest_api" "dataflow" {
  name        = "DataFlow"
  description = "The DataFlow API"

  endpoint_configuration {
    types = ["REGIONAL"]  # Specify REGIONAL instead of EDGE
  }

  body = jsonencode({
    swagger      = "2.0"
    info         = {
      title   = "DataFlow"
      version = "2018-05-24T17:52:00Z"
    }
    host         = "apigateway.${var.AWSRegion}.amazonaws.com"
    basePath     = local.should_not_create_env_resources ? "/Prod" : "/${var.env}"
    schemes      = ["https"]
    definitions  = {
      RequestSchema  = {
        type       = "object"
        required   = ["request"]
        properties = {
          request = {
            type = "string"
          }
        }
      }
      ResponseSchema = {
        type       = "object"
        required   = ["response"]
        properties = {
          response = {
            type = "string"
          }
        }
      }
    }
    paths        = {
      "/DocManagement" = {
        options = {
          consumes  = ["application/json"]
          produces  = ["application/json"]
          responses = {
            "200" = {
              description = "200 response"
              headers     = {
                Access-Control-Allow-Headers = { type = "string" }
                Access-Control-Allow-Methods = { type = "string" }
                Access-Control-Allow-Origin  = { type = "string" }
              }
            }
          }
          x-amazon-apigateway-integration = {
            type                    = "mock"
            passthroughBehavior     = "when_no_match"
            requestTemplates        = {
              "application/json" = "{\"statusCode\": 200}"
            }
            responses               = {
              default = {
                statusCode                      = "200"
                responseParameters              = {
                  "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
                  "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
                  "method.response.header.Access-Control-Allow-Origin"  = "'*'"
                }
              }
            }
          }
        }
        x-amazon-apigateway-any-method = {
          consumes  = ["application/json"]
          produces  = ["application/json"]
          parameters = [
            {
              in       = "body"
              name     = "RequestSchema"
              required = false
              schema   = {
                "$ref" = "#/definitions/RequestSchema"
              }
            }
          ]
          responses  = {
            "200" = {
              description = "200 response"
              schema      = {
                "$ref" = "#/definitions/ResponseSchema"
              }
            }
          }
          security = [{ sigv4 = [] }]
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            type                 = "aws_proxy"
            passthroughBehavior  = "when_no_match"
            uri                  = "arn:aws-us-gov:apigateway:${var.AWSRegion}:lambda:path/2015-03-31/functions/${var.functionDocManagementArn}/invocations"
            responses            = {
              default = {
                statusCode = "200"
              }
            }
          }
        }
      }
    }
    securityDefinitions = {
      sigv4 = {
        type                    = "apiKey"
        name                    = "Authorization"
        in                      = "header"
        x-amazon-apigateway-authtype = "awsSigv4"
      }
    }
  })
}

# Gateway Response - 4XX
resource "aws_api_gateway_gateway_response" "dataflow_default_4xx" {
  rest_api_id = aws_api_gateway_rest_api.dataflow.id
  response_type = "DEFAULT_4XX"
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"
    "gatewayresponse.header.Access-Control-Expose-Headers" = "'Date,X-Amzn-ErrorType'"
  }
}

# Gateway Response - 5XX
resource "aws_api_gateway_gateway_response" "dataflow_default_5xx" {
  rest_api_id = aws_api_gateway_rest_api.dataflow.id
  response_type = "DEFAULT_5XX"
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"
    "gatewayresponse.header.Access-Control-Expose-Headers" = "'Date,X-Amzn-ErrorType'"
  }
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "api_gw_dataflow" {
  rest_api_id = aws_api_gateway_rest_api.dataflow.id
  stage_name  = local.should_not_create_env_resources ? "Prod" : var.env
  depends_on  = [aws_api_gateway_gateway_response.dataflow_default_4xx, aws_api_gateway_gateway_response.dataflow_default_5xx]
}

# Lambda Permissions for each function
locals {
  lambda_permissions = {
    "functionDocManagement" = var.functionDocManagementArn,
    "functionDocRouting"    = var.functionDocRoutingArn,
    "functionIndepth"       = var.functionIndepthArn,
    "functionLLM"           = var.functionLLMArn,
    "functionPastMapper"    = var.functionPastMapperArn,
    "functionPullDocument"  = var.functionPullDocumentArn,
    "functionReturnInfo"    = var.functionReturnInfoArn,
    "functionSAMDetailed"   = var.functionSAMDetailedArn,
    "functionSAMFinder"     = var.functionSAMFinderArn,
    "functionSAMMapper"     = var.functionSAMMapperArn,
  }
}

resource "aws_lambda_permission" "dataflow" {
  for_each     = local.lambda_permissions
  statement_id = "AllowAPIGatewayInvoke"
  action       = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.AWSRegion}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.dataflow.id}/*/*/*"
}