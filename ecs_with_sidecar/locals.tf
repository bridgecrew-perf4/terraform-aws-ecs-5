locals {
  container_definition                = var.register_task_definition ? format("[%s]", data.template_file.container_definition.rendered) : format("%s", data.template_file.container_definition.rendered)
  container_definitions               = replace(local.container_definition, "/\"(null)\"/", "$1")
  security_group = var.security_groups_to_use != null ? flatten([module.securitygroup.security_group_id, var.security_groups_to_use]) : flatten([module.securitygroup.security_group_id])
  # -----------------------------------------------------------------
  # CONTAINER 1
  # -----------------------------------------------------------------
  command                             = jsonencode(var.command)
  entrypoint                          = jsonencode(var.entrypoint)
  environment                         = jsonencode(var.environment)
  environment_files                   = jsonencode(var.environment_files)
  secrets                             = jsonencode(var.secrets)
  port_mappings                       = jsonencode(var.port_mappings)
  repository_credentials              = jsonencode(var.repository_credentials)
  health_check                        = jsonencode(var.healthcheck)
  log_configuration                   = jsonencode(var.log_configuration)
  mount_points            = length(var.mount_points) > 0 ? [
    for mount_point in var.mount_points : {
      containerPath = lookup(mount_point, "containerPath")
      sourceVolume  = lookup(mount_point, "sourceVolume")
      readOnly      = tobool(lookup(mount_point, "readOnly", false))
    }
  ] : var.mount_points

  # -----------------------------------------------------------------
  # CONTAINER 2
  # -----------------------------------------------------------------
  command_sidecar                     = jsonencode(var.command_sidecar)
  entrypoint_sidecar                  = jsonencode(var.entrypoint_sidecar)
  environment_sidecar                 = jsonencode(var.environment_sidecar)
  environment_files_sidecar           = jsonencode(var.environment_files_sidecar)
  secrets_sidecar                     = jsonencode(var.secrets_sidecar)
  port_mappings_sidecar               = jsonencode(var.port_mappings_sidecar)
  repository_credentials_sidecar      = jsonencode(var.repository_credentials_sidecar)
  health_check_sidecar                = jsonencode(var.healthcheck_sidecar )
  log_configuration_sidecar           = jsonencode(var.log_configuration_sidecar)
  mount_points_sidecar      = length(var.mount_points_sidecar) > 0 ? [
    for mount_point in var.mount_points_sidecar : {
      containerPath = lookup(mount_point, "containerPath")
      sourceVolume  = lookup(mount_point, "sourceVolume")
      readOnly      = tobool(lookup(mount_point, "readOnly", false))
    }
  ] : var.mount_points_sidecar
}