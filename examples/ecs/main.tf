module "common" {
  source = "git::git@github.com:tomarv2/terraform-global.git//common?ref=v0.0.1"
}

module "ecs" {
  source = "../../modules/ecs"

  account_id               = "123456789012"
  execution_role_arn       = "arn:aws:iam::123456789012:role/rumse-demo-ecs-role"
  task_role_arn            = "arn:aws:iam::123456789012:role/rumse-demo-ecs-role"
  lb_type                  = "application"
  readonly_root_filesystem = false
  privileged               = false
  # ---------------------------------------------
  # REQUIRED FOR EC2
  # ---------------------------------------------
  key_name                    = "vtomar"
  iam_instance_profile_to_use = "arn:aws:iam::123456789012:instance-profile/rumse-demo-ecs-role-profile"
  # ---------------------------------------------
  # NOTE: REQUIRED FOR FARGATE, COMMENT FOR EC2
  # ---------------------------------------------
  launch_type      = "FARGATE"
  network_mode     = "awsvpc"
  task_cpu         = "512"
  task_memory      = "1024"
  assign_public_ip = true
  # ---------------------------------------------
  # CONTAINER
  # ---------------------------------------------
  # NOTE: Not supported for fargate
  # environment_files = [{ value = "arn:aws:s3:::test-ecs-demo/test.env", type = "s3" }]
  container_image = "nginx"
  # NOTE: Fargate: hostPort and containerPort should match
  port_mappings = [{ hostPort = 80,
    protocol = "tcp",
  containerPort = 80 }]
  container_port = [80]
  security_group_ingress = {
    ecs_default = {
      description = "local traffic"
      from_port   = 0
      protocol    = "-1"
      to_port     = 0
      self        = true
      cidr_blocks = []
      type        = "ingress"
    },
    http = {
      description = "HTTP"
      from_port   = 80
      protocol    = "tcp"
      to_port     = 80
      self        = false
      cidr_blocks = module.common.cidr_for_sec_grp_access
      type        = "ingress"
    }
    ssh = {
      description = "ssh"
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22
      self        = false
      cidr_blocks = module.common.cidr_for_sec_grp_access
      type        = "ingress"
    }
  }
  log_configuration    = { logDriver = "awslogs", options = { awslogs-group = "/ecs/${var.teamid}-${var.prjid}", awslogs-region = var.aws_region, awslogs-stream-prefix = "ecs" } }
  lb_protocol          = "HTTP"
  healthcheck_path     = "/"
  healthcheck_matcher  = "200"
  healthcheck_timeout  = "30"
  healthcheck_interval = "120"
  healthy_threshold    = "2"
  unhealthy_threshold  = "2"
  user_data_file_path  = "scripts/userdata.sh"
  /*
  volumes = [
    {
      name                        = "efs-test"
      host_path                   = ""
      docker_volume_configuration = []
      efs_volume_configuration = [{
        file_system_id : "fs-19e0b81e",
        transit_encryption : "DISABLED",
        root_directory : null,
        transit_encryption_port : null,
        authorization_config : [{
          access_point_id : null,
          iam : null
        }]
      }]
    }
  ]
  mount_points = [
    {
      sourceVolume  = "efs-test",
      containerPath = "/usr/share/nginx/html"
    }
  ]
  entrypoint = [
      "sh",
      "-c"
    ]
  command = [
      "df -h && while true; do echo \"RUNNING\"; done"
    ]
  */
  # ---------------------------------------------
  # DNS
  # ---------------------------------------------
  deploy_route53   = true
  domain_name      = "dev.demo.com"
  names            = ["${var.teamid}-${var.prjid}"]
  types_of_records = ["CNAME"]
  # ----------------------------------------------
  # ----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
