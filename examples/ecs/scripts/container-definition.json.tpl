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
}
