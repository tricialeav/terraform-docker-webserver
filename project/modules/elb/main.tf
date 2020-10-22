resource "aws_lb" "lb" {
  name               = join("-", [var.lb_name, "lb"])
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  subnets            = var.subnets

  tags = var.tags
}

resource "aws_lb_target_group" "lb-target-group" {
  name        = join("-", [var.lb_name, "target-group"])
  port        = var.tg_port
  protocol    = var.tg_protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id
  dynamic "health_check" {
    for_each = var.health_check[*]
    content {
      enabled             = health_check.value.enabled
      interval            = health_check.value.interval
      path                = health_check.value.path
      protocol            = health_check.value.protocol
      healthy_threshold   = health_check.value.healthy_threshold
      unhealthy_threshold = health_check.value.unhealthy_threshold
    }
  }
}