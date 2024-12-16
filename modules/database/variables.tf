variable "env" {
  description = "The environment for the deployment (e.g., dev, prod)"
  type        = string
  default     = "govcloud-dev"
}

variable "aws_region" {
  description = "The AWS region to deploy the database"
  type        = string
  default     = "us-gov-west-1"
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
  sensitive   = true 
  default     = "Pikespeak"  # Provide a default password or leave it empty
}

variable "db_allocated_storage" {
  description = "The allocated storage for the database in GB"
  type        = number
  default     = 10  # Adjust as needed
}