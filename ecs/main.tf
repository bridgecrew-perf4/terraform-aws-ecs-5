module "global" {
  source = "git::git@github.com:tomarv2/terraform-global.git//aws?ref=0.0.1"
}

module "route53" {
  source = "git::git@github.com:tomarv2/terraform-aws-route53.git?ref=0.0.1"

  deploy_route53 = var.deploy_route53 # FEATURE FLAG

  email                  = var.email
  aws_region             = var.aws_region
  dns_name               = var.dns_name
  type_of_record         = var.type_of_record
  account_id             = var.account_id
  evaluate_target_health = var.evaluate_target_health
  teamid                 = var.teamid
  prjid                  = var.prjid
  profile_to_use         = var.profile_to_use
  lb_zoneid              = module.lb.lb_zoneid
}

module "cloudwatch" {
  source = "git::git@github.com:tomarv2/terraform-aws-cloudwatch.git"

  cloudwatch_path = var.cloudwatch_path
  email           = var.email
  teamid          = var.teamid
  prjid           = var.prjid
  aws_region      = var.aws_region
  profile_to_use  = var.profile_to_use
}

module "ec2" {
  source = "git::git@github.com:tomarv2/terraform-aws-ec2.git?ref=0.0.1"

  email                       = var.email
  teamid                      = var.teamid
  prjid                       = var.prjid
  key_name                    = var.key_name
  aws_region                  = var.aws_region
  account_id                  = var.account_id
  iam_instance_profile_to_use = var.iam_instance_profile_to_use
  profile_to_use              = var.profile_to_use
  security_groups_to_use      = local.security_group
  image_id                    = module.global.ecs_ami[var.account_id][var.aws_region]
  inst_type                   = var.inst_type
  user_data_file_path         = var.user_data_file_path
}

module "target_group" {
  source = "git::git@github.com:tomarv2/terraform-aws-target-group.git?ref=0.0.1"

  email                = var.email
  teamid               = var.teamid
  prjid                = var.prjid
  account_id           = var.account_id
  profile_to_use       = var.profile_to_use
  aws_region           = var.aws_region
  lb_protocol          = var.lb_protocol
  lb_port              = var.lb_port
  healthcheck_path     = var.healthcheck_path
  healthy_threshold    = var.healthy_threshold
  healthcheck_matcher  = var.healthcheck_matcher
  healthcheck_timeout  = var.healthcheck_timeout
  unhealthy_threshold  = var.unhealthy_threshold
  healthcheck_interval = var.healthcheck_interval
}

module "lb" {
  source = "git::git@github.com:tomarv2/terraform-aws-lb.git?ref=0.0.1"

  email                  = var.email
  teamid                 = var.teamid
  prjid                  = var.prjid
  account_id             = var.account_id
  profile_to_use         = var.profile_to_use
  aws_region             = var.aws_region
  lb_port                = var.lb_port
  target_group_arn       = module.target_group.target_group_arn
  security_groups_to_use = local.security_group
  lb_type                = var.lb_type
  lb_protocol            = var.lb_protocol
  alb_cert_arn           = var.alb_cert_arn
  alb_ssl_policy         = var.alb_ssl_policy
}

module "securitygroup" {
  source = "git::git@github.com:tomarv2/terraform-aws-securitygroup.git?ref=0.0.1"

  email          = var.email
  teamid         = var.teamid
  prjid          = var.prjid
  profile_to_use = var.profile_to_use
  aws_region     = var.aws_region
  service_ports  = var.security_group_ports
}

locals {
  shared_tags = map(
    "Name", "${var.teamid}-${var.prjid}",
    "Owner", var.email,
    "Team", var.teamid,
    "Project", var.prjid
  )
}
