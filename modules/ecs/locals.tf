locals {
  container_definition  = var.register_task_definition ? format("[%s]", data.template_file.container_definition.rendered) : format("%s", data.template_file.container_definition.rendered)
  container_definitions = replace(local.container_definition, "/\"(null)\"/", "$1")
  security_group        = var.security_groups_to_use != null ? flatten([module.security_group.security_group_id, var.security_groups_to_use]) : flatten([module.security_group.security_group_id])

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
}

locals {
  shared_tags = map(
    "name", "${var.teamid}-${var.prjid}",
    "owner", var.email,
    "team", var.teamid,
    "project", var.prjid
  )
}
