//resource "aws_ecs_capacity_provider" "prov" {
//  name = "prov"
//
//  auto_scaling_group_provider {
//    auto_scaling_group_arn = module.ec2.autoscaling_group_arn #asg.this_autoscaling_group_arn
//  }
//}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.teamid}-${var.prjid}"
  tags = merge(local.shared_tags)
  #checkov:skip=CKV_AWS_65:"Ensure container insights are enabled on ECS cluster"
  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }
  #capacity_providers = var.capacity_providers
  #capacity_providers = ["FARGATE", "FARGATE_SPOT", aws_ecs_capacity_provider.prov.name]

  //  default_capacity_provider_strategy {
  //    capacity_provider = var.ecs_fargate_spot ? "FARGATE_SPOT" : "FARGATE"
  //    #capacity_provider = aws_ecs_capacity_provider.prov.name # "FARGATE_SPOT"
  //    weight            = "1"
  //  }
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

