# Creating an ECS cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_ecs_service" "redis" {
  name             = "redis-${var.task_name}"
  cluster          = aws_ecs_cluster.cluster.id
  task_definition  = aws_ecs_task_definition.task.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  enable_ecs_managed_tags = true

  network_configuration {
    assign_public_ip = false
    subnets          = data.aws_subnet_ids.default_subnet.ids
  }

  lifecycle {
    ignore_changes = [task_definition]
    create_before_destroy = true
  }
}