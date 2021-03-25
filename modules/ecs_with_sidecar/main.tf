module "global" {
  source = "git::git@github.com:tomarv2/terraform-global.git//aws?ref=v0.0.1"
}

module "route53" {
  source = "git::git@github.com:tomarv2/terraform-aws-route53.git?ref=v0.0.1"

  deploy_route53 = var.deploy_route53 # FEATURE FLAG

  aws_region             = var.aws_region
  dns_name               = var.dns_name
  type_of_record         = var.type_of_record
  account_id             = var.account_id
  evaluate_target_health = var.evaluate_target_health
  teamid                 = var.teamid
  prjid                  = var.prjid
  lb_zoneid              = module.lb.lb_zoneid
}

module "ec2" {
  source = "git::git@github.com:tomarv2/terraform-aws-ec2.git?ref=v0.0.1"

  deploy_ec2 = var.launch_type == "FARGATE" ? false : true

  teamid                      = var.teamid
  prjid                       = var.prjid
  key_name                    = var.key_name
  aws_region                  = var.aws_region
  account_id                  = var.account_id
  iam_instance_profile_to_use = var.iam_instance_profile_to_use
  security_groups_to_use      = local.security_group
  image_id                    = module.global.ecs_ami[var.account_id][var.aws_region]
  inst_type                   = var.inst_type
  user_data_file_path         = var.user_data_file_path != null ? var.user_data_file_path : null
}

module "security_group" {
  source = "git::git@github.com:tomarv2/terraform-aws-security-group.git?ref=v0.0.2"

  account_id = var.account_id
  security_group_ingress = var.security_group_ingress
  security_group_egress = var.security_group_egress
  #-------------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
# ---------------------------------------------
# CONTAINER 1
# ---------------------------------------------
module "cloudwatch" {
  source = "git::git@github.com:tomarv2/terraform-aws-cloudwatch.git?ref=v0.0.1"

  cloudwatch_path = var.cloudwatch_path
  teamid          = var.teamid
  prjid           = var.prjid
  aws_region      = var.aws_region
}

module "target_group" {
  source = "git::git@github.com:tomarv2/terraform-aws-target-group.git?ref=v0.0.1"

  teamid               = var.teamid
  prjid                = var.prjid
  account_id           = var.account_id
  aws_region           = var.aws_region
  lb_protocol          = var.lb_protocol
  lb_port              = var.lb_port
  healthcheck_path     = var.healthcheck_path
  healthy_threshold    = var.healthy_threshold
  healthcheck_matcher  = var.healthcheck_matcher
  healthcheck_timeout  = var.healthcheck_timeout
  unhealthy_threshold  = var.unhealthy_threshold
  healthcheck_interval = var.healthcheck_interval
  target_type          = var.launch_type == "FARGATE" ? "ip" : "instance"
}

module "lb" {
  source = "git::git@github.com:tomarv2/terraform-aws-lb.git?ref=v0.0.1"

  teamid                 = var.teamid
  prjid                  = var.prjid
  account_id             = var.account_id
  aws_region             = var.aws_region
  lb_port                = var.lb_port
  target_group_arn       = module.target_group.target_group_arn
  security_groups_to_use = local.security_group
  lb_type                = var.lb_type
  lb_protocol            = var.lb_protocol
  alb_cert_arn           = var.alb_cert_arn
  alb_ssl_policy         = var.alb_ssl_policy
}
# ---------------------------------------------
# CONTAINER 2
# ---------------------------------------------
module "cloudwatch_sidecar" {
  source = "git::git@github.com:tomarv2/terraform-aws-cloudwatch.git?ref=v0.0.1"

  cloudwatch_path             = var.cloudwatch_path
  teamid                      = var.teamid
  prjid                       = var.prjid
  log_group_name              = "${var.teamid}-${var.prjid}-sidecar"
  aws_region                  = var.aws_region
}

module "target_group_sidecar" {
  source                      = "git::git@github.com:tomarv2/terraform-aws-target-group.git?ref=v0.0.1"

  teamid                      = var.teamid
  prjid                       = "${var.prjid}-sidecar"
  account_id                  = var.account_id
  aws_region                  = var.aws_region
  lb_protocol                 = var.lb_protocol_sidecar
  lb_port                     = var.lb_port_sidecar
  healthcheck_path            = var.healthcheck_path_sidecar
  healthy_threshold           = var.healthy_threshold_sidecar
  healthcheck_matcher         = var.healthcheck_matcher_sidecar
  healthcheck_timeout         = var.healthcheck_timeout_sidecar
  unhealthy_threshold         = var.unhealthy_threshold_sidecar
  healthcheck_interval        = var.healthcheck_interval_sidecar
  target_type                 = var.launch_type == "FARGATE" ? "ip" : "instance"
}

module "lb_sidecar" {
  source                      = "git::git@github.com:tomarv2/terraform-aws-lb.git?ref=v0.0.1"

  teamid                      = var.teamid
  prjid                       = "${var.prjid}-sidecar"
  account_id                  = var.account_id
  aws_region                  = var.aws_region
  lb_port                     = var.lb_port_sidecar
  target_group_arn            = module.target_group_sidecar.target_group_arn
  security_groups_to_use      = local.security_group
  lb_type                     = var.lb_type
  lb_protocol                 = var.lb_protocol_sidecar
  alb_cert_arn                = var.alb_cert_arn_sidecar
  alb_ssl_policy              = var.alb_ssl_policy_sidecar
}