# ecs.tf

resource "aws_ecs_cluster" "main" {
  name = "${var.ecs_cluster_name}-cluster"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

