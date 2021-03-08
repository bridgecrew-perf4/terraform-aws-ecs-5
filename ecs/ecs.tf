resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.teamid}-${var.prjid}"
  tags = merge(local.shared_tags)
  #checkov:skip=CKV_AWS_65:"Ensure container insights are enabled on ECS cluster"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
  capacity_providers = var.capacity_providers
}

resource "aws_ecs_task_definition" "ecs_task" {
  count = var.register_task_definition ? 1 : 0

  memory                = var.task_memory
  cpu                   = var.task_cpu
  pid_mode              = var.pid_mode == "" ? null : var.pid_mode
  network_mode          = var.network_mode == "" ? null : var.network_mode
  family                = var.family == "" ? "${var.teamid}-${var.prjid}" : var.family
  task_role_arn         = var.task_role_arn == "" ? "" : var.task_role_arn
  execution_role_arn    = var.execution_role_arn == "" ? "" : var.execution_role_arn
  tags                  = merge(local.shared_tags)
  container_definitions = format("%s", local.container_definitions)

  requires_compatibilities = var.launch_type == "FARGATE" ? ["FARGATE"] : ["EC2"]

  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = volume.value.host_path
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      type       = placement_constraints.value.type
      expression = placement_constraints.value.expression
    }
  }

  depends_on = [module.lb.lb_listener] # changing to handle fargate
  #depends_on = [module.ec2.autoscaling_group_arn]
}

