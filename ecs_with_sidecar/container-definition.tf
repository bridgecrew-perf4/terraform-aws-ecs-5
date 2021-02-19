data "template_file" "container_definition" {
  template                                    = file("scripts/container-definition.json.tpl")

  vars = {
    launch_type                               = var.launch_type
    region                                    = var.aws_region
    account_id                                = var.account_id
    teamid                                    = var.teamid
    prjid                                     = var.prjid
    # -----------------------------------------------------------------
    # CONTAINER 1
    # -----------------------------------------------------------------
    health_check                              = local.health_check == "{}" ? "null" : local.health_check
    log_configuration                         = local.log_configuration == "{}" ? "null" : local.log_configuration
    memory_reservation                        = var.memory_reservation == "" ? "null" :  var.memory_reservation
    command                                   = local.command == "[]" ? "null" : local.command
    entrypoint                                = local.entrypoint == "[]" ? "null" : local.entrypoint
    environment                               = local.environment == "[]" ? "null" : local.environment
    environment_files                         = local.environment_files == "{}" ? "null" : local.environment_files
    secrets                                   = local.secrets == "[]" ? "null" : local.secrets
    mount_points                              = jsonencode(local.mount_points)
    image                                     = var.container_image == "" ? "null" :  var.container_image
    readonly_root_filesystem                  = var.readonly_root_filesystem ? true : false
    privileged                                = var.privileged ? true : false
    repository_credentials                    = local.repository_credentials == "{}" ? "null" : local.repository_credentials
    port_mapping                              = local.port_mappings == "[]" ? "null" : local.port_mappings
    networking_mode                           = var.network_mode == "" ? "null" : var.network_mode
    container_memory                          = var.container_memory == "" ? "null" :  var.container_memory
    container_cpu                             = var.container_cpu == "" ? "null" :  var.container_cpu
    essential                                 = var.essential == "" ? "true" :  var.essential
    # -----------------------------------------------------------------
    # CONTAINER 2
    # -----------------------------------------------------------------
    health_check_sidecar                      = local.health_check_sidecar == "{}" ? "null" : local.health_check_sidecar
    log_configuration_sidecar                 = local.log_configuration_sidecar == "{}" ? "null" : local.log_configuration_sidecar
    memory_reservation_sidecar                = var.memory_reservation_sidecar == "" ? "null" :  var.memory_reservation_sidecar
    command_sidecar                           = local.command_sidecar == "[]" ? "null" : local.command_sidecar
    entrypoint_sidecar                        = local.entrypoint_sidecar == "[]" ? "null" : local.entrypoint_sidecar
    environment_sidecar                       = local.environment_sidecar == "[]" ? "null" : local.environment_sidecar
    environment_files_sidecar                 = local.environment_files_sidecar == "{}" ? "null" : local.environment_files_sidecar
    secrets_sidecar                           = local.secrets_sidecar == "[]" ? "null" : local.secrets_sidecar
    mount_points_sidecar                      = jsonencode(local.mount_points_sidecar)
    image_sidecar                             = var.container_image_sidecar == "" ? "null" :  var.container_image_sidecar
    readonly_root_filesystem_sidecar          = var.readonly_root_filesystem_sidecar ? true : false
    privileged_sidecar                        = var.privileged_sidecar ? true : false
    repository_credentials_sidecar            = local.repository_credentials_sidecar == "{}" ? "null" : local.repository_credentials_sidecar
    port_mapping_sidecar                      = local.port_mappings_sidecar == "[]" ? "null" : local.port_mappings_sidecar
    networking_mode_sidecar                   = var.network_mode_sidecar == "" ? "null" : var.network_mode_sidecar
    container_memory_sidecar                  = var.container_memory_sidecar == "" ? "null" :  var.container_memory_sidecar
    container_cpu_sidecar                     = var.container_cpu_sidecar == "" ? "null" :  var.container_cpu_sidecar
    essential_sidecar                         = var.essential_sidecar == "" ? "true" :  var.essential_sidecar
  }
}
