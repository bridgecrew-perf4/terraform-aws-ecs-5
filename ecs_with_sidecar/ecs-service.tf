locals {
  tg_name_base    = tolist(module.target_group.target_group_arn)
  tg_name_sidecar = tolist(module.target_group_sidecar.target_group_arn)
  //  tg_name = concat(local.tg_name_base, local.tg_name_sidecar)
}

resource "aws_ecs_service" "ecs_service" {
  name    = "${var.teamid}-${var.prjid}-service"
  cluster = aws_ecs_cluster.ecs_cluster.id

  task_definition = aws_ecs_task_definition.ecs_task.*.arn[0]
  desired_count   = var.task_instance_count
  launch_type     = var.launch_type
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  scheduling_strategy                = var.scheduling_strategy
  propagate_tags = var.propagate_tags
  tags           = merge(local.shared_tags)

  dynamic "load_balancer" {
    for_each = formatlist("%s", local.tg_name_base)
    content {
      container_name   = "${var.teamid}-${var.prjid}"
      target_group_arn = element(local.tg_name_base, load_balancer.key)
      container_port   = element(var.container_port, load_balancer.key)
    }
  }

  dynamic "load_balancer" {
    for_each = formatlist("%s", local.tg_name_sidecar)
    content {
      container_name   = "${var.teamid}-${var.prjid}-sidecar"
      target_group_arn = element(local.tg_name_sidecar, load_balancer.key)
      container_port   = element(var.container_port_sidecar, load_balancer.key)
    }
  }

    deployment_controller {
    # The deployment controller type to use. Valid values: CODE_DEPLOY, ECS.
    type = var.deployment_controller_type
  }

  # Note: Network configuration only required for fargate
  # https://www.terraform.io/docs/providers/aws/r/ecs_service.html#network_configuration
  dynamic "network_configuration" {
    for_each = var.network_mode == "awsvpc" ? ["true"] : []
    content {
      security_groups  = [module.securitygroup.security_group_id]
      subnets          = module.global.list_of_subnets[var.account_id][var.aws_region]
      assign_public_ip = var.assign_public_ip
    }
  }

  depends_on = [
    module.lb.lb_listener,
    module.lb_sidecar.lb_listener
  ]
}
