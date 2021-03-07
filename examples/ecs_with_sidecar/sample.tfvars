email                       = "demo@demo.com"
profile_to_use              = "default"
key_name                    = "demo_key"
iam_instance_profile_to_use = "arn:aws:iam::123456789012:instance-profile/ecsInstanceRole"
account_id                  = "123456789012"
execution_role_arn          = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
task_role_arn               = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
task_instance_count         = 1
inst_type                   = "t2.medium"
user_data_file_path         = "scripts/userdata.sh"
lb_type                     = "application"
security_groups_to_use      = ["sg-01234567"]
# -----------------------------------------------------------------
# CONTAINER 1
# -----------------------------------------------------------------
//entry_point                 = []
//command                     = ["python", "security/__main__.py"]
healthcheck_path     = "/"
healthcheck_matcher  = "200"
healthcheck_timeout  = "30"
healthcheck_interval = "120"
healthy_threshold    = "2"
unhealthy_threshold  = "2"
environment          = [{ name = "EC2_REGION", value = "us-west-2" }]
healthcheck = { command = ["CMD-SHELL", "curl -f http://localhost:80/ || exit 1"]
  retries  = 3
  timeout  = 10
  interval = 15
startPeriod = 15 }
log_configuration        = { logDriver = "awslogs", options = { awslogs-group = "/ecs/rumse-demo-ecs", awslogs-region = "us-west-2", awslogs-stream-prefix = "ecs" } }
readonly_root_filesystem = false
container_cpu            = 1024
container_memory         = 1024
task_cpu                 = 2048
task_memory              = 2048
container_image          = "nginx"
port_mappings = [{ hostPort = 0,
  protocol = "tcp",
containerPort = 80 }]
container_port        = [80]
lb_port               = [80]
sercurity_group_ports = [22, 80]
lb_protocol           = "HTTP"
essential             = true
privileged            = true
# -----------------------------------------------------------------
# CONTAINER 2
# -----------------------------------------------------------------
container_image_sidecar = "bitnami/apache:latest"
port_mappings_sidecar   = [{ hostPort = 0, protocol = "tcp", containerPort = 8080 }]
container_port_sidecar  = [8080]
lb_port_sidecar         = [8080]
lb_protocol_sidecar     = "HTTP"
environment_sidecar     = [{ name = "EC2_REGION", value = "us-west-2" }]
healthcheck_sidecar = { command = ["CMD-SHELL", "curl -f http://localhost:8080/ || exit 1"]
  retries  = 3
  timeout  = 10
  interval = 15
startPeriod = 15 }
log_configuration_sidecar        = { logDriver = "awslogs", options = { awslogs-group = "/ecs/rumse-demo-ecs-sidecar", awslogs-region = "us-west-2", awslogs-stream-prefix = "ecs" } }
readonly_root_filesystem_sidecar = false
container_cpu_sidecar            = 1024
container_memory_sidecar         = 1024
task_cpu_sidecar                 = 2048
task_memory_sidecar              = 2048
essential_sidecar                = true
privileged_sidecar               = true
healthcheck_path_sidecar         = "/"
healthcheck_matcher_sidecar      = "200"
healthcheck_timeout_sidecar      = "30"
healthcheck_interval_sidecar     = "120"
healthy_threshold_sidecar        = "2"
unhealthy_threshold_sidecar      = "2"
# ------------------------------------------------------------------
# Do not change the teamid, prjid once set.
teamid = "rumse"
prjid  = "demo-ecs"

