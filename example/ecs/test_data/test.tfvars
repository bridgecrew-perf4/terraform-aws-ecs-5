email                       = "varun.tomar@databricks.com"
profile_to_use              = "default"
key_name                    = "vtomar"
iam_instance_profile_to_use = "arn:aws:iam::755921336062:instance-profile/security-dispatch-ecs-mgmt-role-profile"
account_id                  = "755921336062"

environment_files           = [{value = "arn:aws:s3:::test-ecs-demo/test.env", type = "s3"}]
container_image             = "nginx"
port_mappings               = [{hostPort = 0,
                                protocol = "tcp",
                                containerPort = 80}]
container_port              = [80]
sercurity_group_ports     = [22,80]
execution_role_arn          = "arn:aws:iam::755921336062:role/security-dispatch-ecs-mgmt-role"
task_role_arn               = "arn:aws:iam::755921336062:role/security-dispatch-ecs-mgmt-role"
log_configuration             = {logDriver = "awslogs",options = {awslogs-group = "/ecs/security-demo-ecs",awslogs-region = "us-west-2", awslogs-stream-prefix = "ecs"}}
readonly_root_filesystem      = false
lb_protocol                   = "HTTP"
lb_type                       = "application"
//entry_point                 = []
//command                     = ["python", "security/__main__.py"]
healthcheck_path              = "/"
healthcheck_matcher           = "200"
healthcheck_timeout           = "30"
healthcheck_interval          = "120"
healthy_threshold             = "2"
unhealthy_threshold           = "2"
user_data_file_path           = "scripts/userdata.sh"
# ------------------------------------------------------------------
# Do not change the teamid, prjid once set.
teamid                      = "security"
prjid                       = "demo-ecs"

