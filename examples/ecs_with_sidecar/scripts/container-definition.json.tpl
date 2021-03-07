{
  "name": "${teamid}-${prjid}",
  "image": "${image}",
  "privileged": ${privileged},
  "entrypoint": ${entrypoint},
  "essential": ${essential},
  "command": ${command},
  "requiresCompatibilities": [
    "${launch_type}"
  ],
  "portMappings": ${port_mapping},
  "networkMode": "${networking_mode}",
  "environment": ${environment},
  "environmentFiles": ${environment_files},
  "secrets": ${secrets},
  "mountPoints": ${mount_points},
  "memoryReservation": ${memory_reservation},
  "memory": ${container_memory},
  "cpu": ${container_cpu},
  "readonlyRootFilesystem": ${readonly_root_filesystem},
  "healthCheck": ${health_check},
  "logConfiguration": ${log_configuration}
},
{
  "name": "${teamid}-${prjid}-sidecar",
  "image": "${image_sidecar}",
  "privileged": ${privileged_sidecar},
  "entrypoint": ${entrypoint_sidecar},
  "essential": ${essential_sidecar},
  "command": ${command_sidecar},
  "requiresCompatibilities": [
    "${launch_type}"
  ],
  "portMappings": ${port_mapping_sidecar},
  "networkMode": "${networking_mode_sidecar}",
  "environment": ${environment_sidecar},
  "environmentFiles": ${environment_files_sidecar},
  "secrets": ${secrets_sidecar},
  "mountPoints": ${mount_points_sidecar},
  "memoryReservation": ${memory_reservation_sidecar},
  "memory": ${container_memory_sidecar},
  "cpu": ${container_cpu_sidecar},
  "readonlyRootFilesystem": ${readonly_root_filesystem_sidecar},
  "healthCheck": ${health_check_sidecar},
  "logConfiguration": ${log_configuration_sidecar}
}