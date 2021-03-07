module "ecs" {
  source = "../../ecs"

  email                       = "demo@demo.com"
  key_name                    = "demo-key"
  iam_instance_profile_to_use = "arn:aws:iam::123456789012:instance-profile/rumse-demo-role-profile"
  account_id                  = "123456789012"
  execution_role_arn          = "arn:aws:iam::123456789012:role/rumse-demo-role"
  task_role_arn               = "arn:aws:iam::123456789012:role/rumse-demo-role"
  lb_type                     = "application"
  # ---------------------------------------------
  # CONTAINER
  # ---------------------------------------------
  environment_files = [{ value = "arn:aws:s3:::test-ecs-demo/test.env", type = "s3" }]
  container_image   = "nginx"
  port_mappings = [{ hostPort = 0,
    protocol = "tcp",
  containerPort = 80 }]
  container_port           = [80]
  security_group_ports     = [22, 80]
  log_configuration        = { logDriver = "awslogs", options = { awslogs-group = "/ecs/rumse-demo-ecs-test", awslogs-region = "us-west-2", awslogs-stream-prefix = "ecs" } }
  readonly_root_filesystem = false
  lb_protocol              = "HTTP"
  healthcheck_path         = "/"
  healthcheck_matcher      = "200"
  healthcheck_timeout      = "30"
  healthcheck_interval     = "120"
  healthy_threshold        = "2"
  unhealthy_threshold      = "2"
  user_data_file_path      = "scripts/userdata.sh"
  # ----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
