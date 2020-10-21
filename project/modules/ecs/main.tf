resource "aws_security_group" "ecs" {
  name        = "ecs_sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    description = "Access containers from the internet."
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_ecs_cluster" "web_app" {
  name               = "web_app_cluster"
  capacity_providers = "FARGATE"
  setting = {
    name  = "containerInsights",
    value = "enabled"
  }
  tags = var.tags
}

resource "aws_kms_key" "ecs_logs_key" {
  description             = "ECS Logs Key"
  deletion_window_in_days = 7
  tags                    = var.tags
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/ecs-logs"
  target_key_id = aws_kms_key.ecs_logs_key.key_id
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "ecs_logs"
  retention_in_days = 5
  kms_key_id        = aws_kms_key.ecs_logs_key.key_id
  tags              = var.tags
}

module "ecs-fargate-task-definition" {
  source           = "cn-terraform/ecs-fargate-task-definition/aws"
  version          = "1.0.16"
  container_cpu    = 256
  container_memory = 512
  container_image  = var.container_image
  container_name   = var.container_name
  port_mappings    = var.port_mappings
  name_prefix = var.env
  log_configuration = {
    log_driver = var.log_driver
    options = {
      awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
      awslogs-region        = var.region
      awslogs-stream-prefix = "awslogs-${var.container_name}-service"
    }
  }
  essential = var.essential
}
