data "template_file" "container_definition" {
  template                                    = file("scripts/container-definition.json.tpl")

  vars = {
    launch_type                               = var.launch_type
    region                                    = var.aws_region
    account_id                                = var.account_id
    teamid                                    = var.teamid
    prjid                                     = var.prjid

    health_check                              = local.health_check == "{}" ? "null" : local.health_check
    log_configuration                         = local.log_configuration == "{}" ? "null" : local.log_configuration
    memory_reservation                        = var.memory_reservation == "" ? "null" :  var.memory_reservation
    command                                   = local.command == "[]" ? "null" : local.command
    entrypoint                                = local.entrypoint == "[]" ? "null" : local.entrypoint
    environment                               = local.environment == "[]" ? "null" : local.environment
    environment_files                         = local.environment_files == "" ? "null" : local.environment_files
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
  }
}
