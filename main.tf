terraform
resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-ecs-cluster"
}

resource "aws_ecs_task_definition" "medusa_task" {
  family                = "medusa-task-definition"
  cpu                   = 256
  memory                = 512
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name      = "medusa-container"
      image     = "medusajs/medusa:latest"
      portMappings = [
        {
          containerPort = 9000
          hostPort      = 9000
        }
      ]
      environment = [
        {
          name  = "MEDUSA_DB_USERNAME"
          value = "mydbuser"
        },
        {
          name  = "MEDUSA_DB_PASSWORD"
          value = "mydbpassword"
        },
        {
          name  = "MEDUSA_DB_HOST"
          value = "(link unavailable)"
        },
        {
          name  = "MEDUSA_DB_PORT"
          value = "5432"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.name
  task_definition = aws_ecs_task_definition.medusa_task.arn
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  network_configuration {
    awsvpc_configuration {
      subnets          = ["<subnet-0d8556b1f3147578b>"]
      security_groups = ["<sg-0924a4b2e1c615373>"]
      assign_public_ip = "ENABLED"
    }
  }
}
