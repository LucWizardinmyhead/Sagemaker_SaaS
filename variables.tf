
variable "env" {
  description = "Deployment environment"
  type = string
  default = "dev"
}

variable "auth_role_name" {
  description = "Name of the auth role"
  type        = string
  default     = "dev-auth"
}

variable "unauth_role_name" {
  description = "Name of the unauth role"
  type        = string
  default     = "dev-unauth"
}

variable "lambda_exec_role" {
  description = "Name of the lambda exec role"
  type        = string
  default     = "lambda_exec_role"
}

variable "deployment_bucket_name" {
  description = "Name of the deployment bucket"
  type        = string
  default     = "terraform-config-dev-west-1"
}

variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
  default     = "dev_user_pool"
}

variable "identity_pool_name" {
  description = "Name of the Cognito Identity Pool"
  type        = string
  default     = "dev_identity_pool"
}

variable "data_flow" {
  description = "Data flow configuration"
  type        = string
  default     = "dataflow"
}

variable "db_instance_class" {
  description = "The instance class for the database"
  type        = string
  default     = "db.t3.micro"  # You can adjust this as needed
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "pikes_peak"  # Provide a default name or leave it empty
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "pikespeak"  # Provide a default username or leave it empty
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true  # Mark as sensitive
  default     = "Pikespeak"  # Provide a default password or leave it empty
}

variable "db_allocated_storage" {
  description = "The allocated storage for the database in GB"
  type        = number
  default     = 10  # Adjust as needed
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "BDTool_dev"
}

variable "capacity_providers" {
  description = "The capacity providers for the ECS cluster"
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}

# variable "s3_key" {
#   description = "S3 key for Lambda function code"
#   type        = string
# }

# variable "secret_name" {
#   description = "Secret name for database credentials"
#   type        = string
# }

# variable "db_host" {
#   description = "Database host"
#   type        = string
# }

# variable "secret_region" {
#   description = "Region where the secret is stored"
#   type        = string
# }

# variable "openai_api_key" {
#   description = "OpenAI API Key"
#   type        = string
# }

# variable "region_name_sagemaker" {
#   description = "SageMaker region name"
#   type        = string
# }

# variable "aws_access_key_id_sagemaker" {
#   description = "AWS access key for SageMaker"
#   type        = string
# }

# variable "aws_secret_access_key_sagemaker" {
#   description = "AWS secret key for SageMaker"
#   type        = string
# }

# variable "endpoint_name_sagemaker" {
#   description = "SageMaker endpoint name"
#   type        = string
# }

# variable "inference_name_llm" {
#   description = "LLM inference name"
#   type        = string
# }

# variable "region_name_llm" {
#   description = "LLM region name"
#   type        = string
# }

# variable "endpoint_name_llm" {
#   description = "LLM endpoint name"
#   type        = string
# }
