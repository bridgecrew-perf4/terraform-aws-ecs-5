resource "aws_ecs_cluster" "ecs_cluster" {
  count = var.deploy_ecs ? 1 : 0

  name = "${var.teamid}-${var.prjid}"
  tags = merge(local.shared_tags)
  #checkov:skip=CKV_AWS_65:"Ensure container insights are enabled on ECS cluster"
  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_task_definition" "ecs_task" {
  count = var.deploy_ecs && var.register_task_definition ? 1 : 0

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
      name = volume.value.name

      host_path = lookup(volume.value, "host_path", null)

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])
        content {
          file_system_id          = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory          = lookup(efs_volume_configuration.value, "root_directory", null)
          transit_encryption      = lookup(efs_volume_configuration.value, "transit_encryption", null)
          transit_encryption_port = lookup(efs_volume_configuration.value, "transit_encryption_port", null)
          dynamic "authorization_config" {
            for_each = lookup(efs_volume_configuration.value, "authorization_config", [])
            content {
              access_point_id = lookup(authorization_config.value, "access_point_id", null)
              iam             = lookup(authorization_config.value, "iam", null)
            }
          }
        }
      }
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
