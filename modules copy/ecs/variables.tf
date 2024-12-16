variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "BDTool_gov_dev"
}

# variable "capacity_providers" {
#   description = "The capacity providers for the ECS cluster"
#   type        = list(string)
#   default     = ["FARGATE", "FARGATE_SPOT"]
# }