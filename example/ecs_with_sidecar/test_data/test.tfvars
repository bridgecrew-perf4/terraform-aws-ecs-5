email                                 = "varun.tomar@databricks.com"
profile_to_use                        = "default"
key_name                              = "vtomar"
iam_instance_profile_to_use           = "arn:aws:iam::755921336062:instance-profile/ecsInstanceRole"
account_id                            = "755921336062"
execution_role_arn                    = "arn:aws:iam::755921336062:role/ecsTaskExecutionRole"
task_role_arn                         = "arn:aws:iam::755921336062:role/ecsTaskExecutionRole"
lb_type                               = "application"
# -----------------------------------------------------------------
# CONTAINER 1
# -----------------------------------------------------------------
environment                           = [{name = "EC2_REGION",value = "us-west-2"}]
lb_protocol                           = "HTTP"
lb_port                               = [80]
healthcheck_path                      = "/"
healthcheck_matcher                   = "200"
healthcheck_timeout                   = "30"
healthcheck_interval                  = "120"
healthy_threshold                     = "2"
unhealthy_threshold                   = "2"
healthcheck                           = {command = ["CMD-SHELL", "curl -f http://localhost:80/ || exit 1"]
                                       retries     = 3
                                       timeout     = 30
                                       interval    = 120
                                       startPeriod = 300}
log_configuration                     = {logDriver = "awslogs",options = {awslogs-group = "/ecs/rumse-demo-ecs",awslogs-region = "us-west-2", awslogs-stream-prefix = "ecs"}}
readonly_root_filesystem              = false
container_cpu                         = 512
container_memory                      = 512
task_cpu                              = 1024
task_memory                           = 1024
container_image                       = "nginx"
port_mappings                         = [{hostPort = 0,protocol = "tcp",containerPort = 80}]
container_port                        = [80]
# -----------------------------------------------------------------
# CONTAINER 2
# -----------------------------------------------------------------
lb_protocol_sidecar                   = "HTTP"
lb_port_sidecar                       = [8080]
healthcheck_path_sidecar              = "/"
healthcheck_matcher_sidecar           = "200"
healthcheck_timeout_sidecar           = "30"
healthcheck_interval_sidecar          = "120"
healthy_threshold_sidecar             = "2"
unhealthy_threshold_sidecar           = "2"
port_mappings_sidecar                 = [{hostPort = 0,protocol = "tcp",containerPort = 8080}]
container_port_sidecar                = [8080]
container_image_sidecar               = "bitnami/apache:latest"
environment_sidecar                   = [{name = "EC2_REGION",value = "us-west-2"}]
log_configuration_sidecar             = {logDriver = "awslogs",options = {awslogs-group = "/ecs/rumse-demo-ecs-sidecar",awslogs-region = "us-west-2",awslogs-stream-prefix = "ecs"}}
readonly_root_filesystem_sidecar      = false
container_cpu_sidecar                 = 512
container_memory_sidecar              = 512
task_cpu_sidecar                      = 1024
task_memory_sidecar                   = 1024
user_data_file_path                   = "scripts/userdata.sh"
# ------------------------------------------------------------------
# Do not change the teamid, prjid once set.
teamid                                = "rumse"
prjid                                 = "demo-ecs"


