### Elastic Container Service ###
# Task Definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.task_definition_name
  network_mode             = var.task_definition_network_mode
  requires_compatibilities = [var.task_definition_type]
  cpu                      = var.task_definition_cpu
  memory                   = var.task_definition_memory
  task_role_arn            = data.aws_iam_role.ecs_task_role.arn
  execution_role_arn       = data.aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = var.task_definition_container_name
      image     = "${aws_ecr_repository.image_repo.repository_url}:latest"
      cpu       = var.task_definition_container_cpu
      memory    = var.task_definition_container_memory
      essential = true
      portMappings = [
        {
          containerPort = var.task_definition_port
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = var.task_definition_operation_system
    cpu_architecture        = var.task_definition_cpu_architecture
  }
}

# ECS Cluster 
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  tags = {
    name = var.cluster_name
  }
}

# ECS Service 
resource "aws_ecs_service" "ecs_service" {
  name                = var.service_name
  cluster             = aws_ecs_cluster.ecs_cluster.id
  launch_type         = var.service_launch_type
  platform_version    = "LATEST"
  propagate_tags      = "SERVICE"
  task_definition     = aws_ecs_task_definition.ecs_task_definition.arn
  scheduling_strategy = var.service_scheduling_strategy
  desired_count       = var.service_desired_count
  # health_check_grace_period_seconds = var.service_health_check_period

  network_configuration {
    security_groups  = [aws_security_group.sg_container.id]
    subnets          = [aws_subnet.subnet_ap_a.id, aws_subnet.subnet_ap_a.id]
    assign_public_ip = var.service_assign_public_ip
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.tgp_web_80.arn
    container_name   = var.task_definition_container_name
    container_port   = var.task_definition_port
  }

  deployment_controller {
    type = var.service_deployment
  }

  tags = {
    name = var.service_name
  }
}
