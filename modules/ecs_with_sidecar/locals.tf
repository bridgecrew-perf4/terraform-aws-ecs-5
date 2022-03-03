locals {
  container_definition  = var.register_task_definition ? format("[%s]", join("", data.template_file.container_definition.*.rendered)) : format("%s", join("", data.template_file.container_definition.*.rendered))
  container_definitions = replace(local.container_definition, "/\"(null)\"/", "$1")
  security_groups       = var.security_groups != null ? flatten([module.security_group.security_group_id, var.security_groups]) : flatten([module.security_group.security_group_id])
  # -----------------------------------------------------------------
  # CONTAINER 1
  # -----------------------------------------------------------------
  command                = jsonencode(var.command)
  entrypoint             = jsonencode(var.entrypoint)
  environment            = jsonencode(var.environment)
  environment_files      = jsonencode(var.environment_files)
  secrets                = jsonencode(var.secrets)
  port_mappings          = jsonencode(var.port_mappings)
  repository_credentials = jsonencode(var.repository_credentials)
  health_check           = jsonencode(var.healthcheck)
  log_configuration      = jsonencode(var.log_configuration)
  mount_points = length(var.mount_points) > 0 ? [
    for mount_point in var.mount_points : {
      containerPath = lookup(mount_point, "containerPath")
      sourceVolume  = lookup(mount_point, "sourceVolume")
      readOnly      = tobool(lookup(mount_point, "readOnly", false))
    }
  ] : var.mount_points

  # -----------------------------------------------------------------
  # CONTAINER 2
  # -----------------------------------------------------------------
  command_sidecar                = jsonencode(var.command_sidecar)
  entrypoint_sidecar             = jsonencode(var.entrypoint_sidecar)
  environment_sidecar            = jsonencode(var.environment_sidecar)
  environment_files_sidecar      = jsonencode(var.environment_files_sidecar)
  secrets_sidecar                = jsonencode(var.secrets_sidecar)
  port_mappings_sidecar          = jsonencode(var.port_mappings_sidecar)
  repository_credentials_sidecar = jsonencode(var.repository_credentials_sidecar)
  health_check_sidecar           = jsonencode(var.healthcheck_sidecar)
  log_configuration_sidecar      = jsonencode(var.log_configuration_sidecar)
  mount_points_sidecar = length(var.mount_points_sidecar) > 0 ? [
    for mount_point in var.mount_points_sidecar : {
      containerPath = lookup(mount_point, "containerPath")
      sourceVolume  = lookup(mount_point, "sourceVolume")
      readOnly      = tobool(lookup(mount_point, "readOnly", false))
    }
  ] : var.mount_points_sidecar

  tg_name_base    = tolist(module.target_group.target_group_arn)
  tg_name_sidecar = tolist(module.target_group_sidecar.target_group_arn)

  shared_tags = tomap(
    {
      "Name"    = "${var.teamid}-${var.prjid}",
      "team"    = var.teamid,
      "project" = var.prjid
    }
  )

  account_info        = var.account_id != null ? var.account_id : data.aws_caller_identity.current.account_id
  override_aws_region = var.aws_region != null ? var.aws_region : data.aws_region.current.name
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
