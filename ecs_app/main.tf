locals {
  application_name = "tf-kutt-app"
  launch_type      = "FARGATE"
}
resource "aws_ecs_cluster" "this" {
  name = local.application_name
}

#resource "aws_ecs_service" "this" {
#  name        = local.application_name
#  cluster     = aws_ecs_cluster.this.arn
#  launch_type = local.launch_type
#
#
#  deployment_maximum_percent         = 200
#  deployment_minimum_healthy_percent = 0
#  desired_count                      = 1
#  task_definition                    = ""
#
#  network_configuration {
#    assign_public_ip = true
#    security_groups = [data.aws_security_group.this.id]
#    subnets = data.aws_subnet_ids.this.ids
#  }
#}