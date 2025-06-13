variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster."
  default     = "BDTool"  # Default value, override as needed
}

resource "aws_ecs_cluster" "bdtool_cluster" {
  name = var.ecs_cluster_name

  # Uncomment and adjust if using Fargate:
  # capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  # Enable CloudWatch Container Insights (optional)
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = var.ecs_cluster_name
  }
}