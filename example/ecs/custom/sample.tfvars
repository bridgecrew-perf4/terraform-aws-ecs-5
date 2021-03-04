email                       = "demo@demo.com"
profile_to_use              = "default"
key_name                    = "demo_key"
iam_instance_profile_to_use = "arn:aws:iam::123456789012:instance-profile/rumse-ecs-mgmt-role-profile"
account_id                  = "123456789012"

environment_files = [{ value = "arn:aws:s3:::test-ecs-demo/test.env", type = "s3" }]
container_image   = "nginx"
port_mappings = [{ hostPort = 0,
  protocol = "tcp",
containerPort = 80 }]
container_port           = [80]
sercurity_group_ports     = [22,80]
execution_role_arn       = "arn:aws:iam::123456789012:role/rumse-ecs-mgmt-role"
task_role_arn            = "arn:aws:iam::123456789012:role/rumse-ecs-mgmt-role"
log_configuration        = { logDriver = "awslogs", options = { awslogs-group = "/ecs/rumse-demo-ecs", awslogs-region = "us-west-2", awslogs-stream-prefix = "ecs" } }
readonly_root_filesystem = false
lb_protocol              = "HTTP"
lb_type                  = "application"
//entry_point                 = []
//command                     = ["python", "rumse/__main__.py"]
healthcheck_path     = "/"
healthcheck_matcher  = "200"
healthcheck_timeout  = "30"
healthcheck_interval = "120"
healthy_threshold    = "2"
unhealthy_threshold  = "2"
user_data_file_path  = "../custom/userdata.sh"
# ------------------------------------------------------------------
# Do not change the teamid, prjid once set.
teamid = "rumse"
prjid  = "demo-ecs"

