terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      version = "~> 3.74"
    }
    template = {
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "common" {
  source = "git::git@github.com:tomarv2/terraform-global.git//common?ref=v0.0.1"
}

module "ecs" {
  source = "../../modules/ecs_with_sidecar"

  key_name             = "vtomar"
  iam_instance_profile = "arn:aws:iam::123456789012:instance-profile/demo-role-profile"
  execution_role_arn   = "arn:aws:iam::123456789012:role/demo-role"
  task_role_arn        = "arn:aws:iam::123456789012:role/demo-role"
  lb_type              = "application"
  # user_data_file_path  = "scripts/userdata.sh"
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
    container_specific = {
      description = "application port"
      from_port   = 8080
      protocol    = "tcp"
      to_port     = 8080
      self        = false
      cidr_blocks = module.common.cidr_for_sec_grp_access
      type        = "ingress"
    }
  }
  # ---------------------------------------------
  # NOTE: REQUIRED FOR FARGATE, COMMENT FOR EC2
  # ---------------------------------------------
  launch_type      = "FARGATE"
  network_mode     = "awsvpc"
  task_cpu         = "512"
  task_memory      = "1024"
  assign_public_ip = true
  # ---------------------------------------------
  # CONTAINER 1
  # ---------------------------------------------
  # NOTE: Not supported for fargate
  # environment_files = [{ value = "arn:aws:s3:::test-ecs-demo/test.env", type = "s3" }]
  container_image = "nginx"
  # NOTE: Fargate: hostPort and containerPort should match
  port_mappings = [{ hostPort = 80,
    protocol = "tcp",
  containerPort = 80 }]
  container_port           = [80]
  log_configuration        = { logDriver = "awslogs", options = { awslogs-group = "/ecs/${var.teamid}-${var.prjid}", awslogs-region = var.region, awslogs-stream-prefix = "ecs" } }
  readonly_root_filesystem = false
  lb_protocol              = "HTTP"
  healthcheck_path         = "/"
  healthcheck_matcher      = "200"
  healthcheck_timeout      = "30"
  healthcheck_interval     = "120"
  healthy_threshold        = "2"
  unhealthy_threshold      = "2"
  # ---------------------------------------------
  # CONTAINER 2
  # ---------------------------------------------
  container_image_sidecar = "bitnami/apache:latest"
  # Fargate: hostPort and containerPort should match
  port_mappings_sidecar = [{ hostPort = 8080,
    protocol = "tcp",
  containerPort = 8080 }]
  container_port_sidecar           = [8080]
  lb_port_sidecar                  = [8080]
  log_configuration_sidecar        = { logDriver = "awslogs", options = { awslogs-group = "/ecs/${var.teamid}-${var.prjid}-sidecar", awslogs-region = var.region, awslogs-stream-prefix = "ecs" } }
  readonly_root_filesystem_sidecar = false
  lb_protocol_sidecar              = "HTTP"
  healthcheck_path_sidecar         = "/"
  healthcheck_matcher_sidecar      = "200"
  healthcheck_timeout_sidecar      = "30"
  healthcheck_interval_sidecar     = "120"
  healthy_threshold_sidecar        = "2"
  unhealthy_threshold_sidecar      = "2"
  # ---------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
