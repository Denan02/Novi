resource "aws_ecs_cluster" "arm_ecs_cluster" {

  name = "arm_ecs_cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_task_definition" "task_dummy" {
  family = "database-task-dummy"
  container_definitions = jsonencode([
    {
      name   = "placeholder"
      image  = "amazonlinux"
      cpu    = 0
      memory = 128
    }
  ])
}

resource "aws_ecs_service" "frontend_service" {
  cluster                            = aws_ecs_cluster.arm_ecs_cluster.id
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  desired_count                      = 1
  name                               = "frontend-service"
  task_definition                    = aws_ecs_task_definition.task_dummy.arn
}

resource "aws_ecs_service" "database_service" {
  cluster                            = aws_ecs_cluster.arm_ecs_cluster.id
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  desired_count                      = 1
  name                               = "database-service"
  task_definition                    = aws_ecs_task_definition.task_dummy.arn
}
