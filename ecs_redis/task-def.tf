resource "aws_ecs_task_definition" "task" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 2048

  container_definitions = jsonencode([
    {
      name: "redis",
      image: "redis:latest",
      cpu: 512,
      memory: 256,
      essential: true,
      portMappings: [
        {
          containerPort: 6379,
          hostPort: 6379,
        },
      ],
    },
  ])
}