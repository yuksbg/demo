resource "aws_ecs_task_definition" "this" {
  container_definitions = jsonencode([
    {
      name      = "kutt-app"
      image     = "nginx"
      cpu: 256,
      memory: 512,
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
  ])
  family                = local.application_name
  requires_compatibilities = [local.launch_type]
  cpu = 256
  memory = 512
  network_mode = "awsvpc"
}