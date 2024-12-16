resource "aws_ecs_cluster" "bdtool_cluster" {
  name = "BDTool_gov_dev"
  #capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  tags = {
    Name = "BDTool_gov_dev"
  }
}