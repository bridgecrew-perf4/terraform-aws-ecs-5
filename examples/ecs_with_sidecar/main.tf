module "ecs" {
  source = "../../ecs_with_sidecar"

  email                       = "demo@demo.com"
  key_name                    = "demo-key"
  account_id                  = "123456789012"
  dns_name                    = "demo.demo.com"
  iam_instance_profile_to_use = "arn:aws:iam::123456789012:instance-profile/rumse-demo-role-profile"
  execution_role_arn          = "arn:aws:iam::123456789012:role/rumse-demo-role"
  task_role_arn               = "arn:aws:iam::123456789012:role/rumse-demo-role"
  user_data_file_path         = "scripts/userdata.sh"
  # ---------------------------------------------
  # CONTAINER 1
  # ---------------------------------------------
  container_image = "nginx"
  port_mappings = [{ hostPort = 0,
    protocol = "tcp",
  containerPort = 80 }]
  lb_protocol          = "HTTP"
  lb_type              = "application"
  healthcheck_path     = "/"
  healthcheck_matcher  = "200"
  healthcheck_timeout  = "30"
  healthcheck_interval = "120"
  healthy_threshold    = "2"
  unhealthy_threshold  = "2"
  log_configuration    = { logDriver = "awslogs", options = { awslogs-group = "/ecs/rumse-demo-ecs-test", awslogs-region = "us-west-2", awslogs-stream-prefix = "ecs" } }
  # ---------------------------------------------
  # CONTAINER 2
  # ---------------------------------------------
  container_image_sidecar = "nginx"
  port_mappings_sidecar = [{ hostPort = 0,
    protocol = "tcp",
  containerPort = 80 }]
  lb_protocol_sidecar          = "HTTP"
  lb_type_sidecar              = "application"
  healthcheck_path_sidecar     = "/"
  healthcheck_matcher_sidecar  = "200"
  healthcheck_timeout_sidecar  = "30"
  healthcheck_interval_sidecar = "3"
  healthy_threshold_sidecar    = "2"
  unhealthy_threshold_sidecar  = "3"
  log_configuration_sidecar    = { logDriver = "awslogs", options = { awslogs-group = "/ecs/rumse-demo-ecs-test", awslogs-region = "us-west-2", awslogs-stream-prefix = "ecs" } }

  # ---------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
