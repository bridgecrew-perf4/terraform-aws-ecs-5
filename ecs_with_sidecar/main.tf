//terraform {
//  required_version            = ">= 0.14"
//  required_providers {
//    aws = {
//      version                     = "~> 2.61"
//    }
//  }
//}

provider "aws" {
  region                      = var.aws_region
  profile                     = var.profile_to_use
}

module "global" {
  source                      = "git::git@github.com:tomarv2/terraform-global.git//aws?ref=0.0.1"
}

module "route53" {
  source                      = "git::git@github.com:tomarv2/terraform-aws-route53.git?ref=0.0.1"

  deploy_route53              = var.deploy_route53 # FEATURE FLAG

  email                       = var.email
  aws_region                  = var.aws_region
  dns_name                    = var.dns_name
  type_of_record              = var.type_of_record
  account_id                  = var.account_id
  evaluate_target_health      = var.evaluate_target_health
  teamid                      = var.teamid
  prjid                       = var.prjid
  profile_to_use              = var.profile_to_use
  lb_zoneid                   = module.lb.lb_zoneid
}

module "cloudwatch" {
  source                      = "git::git@github.com:tomarv2/terraform-aws-cloudwatch.git?ref=0.0.1"

  cloudwatch_path             = var.cloudwatch_path
  email                       = var.email
  teamid                      = var.teamid
  prjid                       = var.prjid
  aws_region                  = var.aws_region
  profile_to_use              = var.profile_to_use
}

module "ec2" {
  source                      = "git::git@github.com:tomarv2/terraform-aws-ec2.git?ref=0.0.1"

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
  source                      = "git::git@github.com:tomarv2/terraform-aws-target-group.git?ref=0.0.1"

  email                       = var.email
  teamid                      = var.teamid
  prjid                       = var.prjid
  account_id                  = var.account_id
  profile_to_use              = var.profile_to_use
  aws_region                  = var.aws_region
  lb_protocol                 = var.lb_protocol
  lb_port                     = var.lb_port
  healthcheck_path            = var.healthcheck_path
  healthy_threshold           = var.healthy_threshold
  healthcheck_matcher         = var.healthcheck_matcher
  healthcheck_timeout         = var.healthcheck_timeout
  unhealthy_threshold         = var.unhealthy_threshold
  healthcheck_interval        = var.healthcheck_interval
}

module "lb" {
  source                      = "git::git@github.com:tomarv2/terraform-aws-lb.git?ref=0.0.1"

  email                       = var.email
  teamid                      = var.teamid
  prjid                       = var.prjid
  account_id                  = var.account_id
  profile_to_use              = var.profile_to_use
  aws_region                  = var.aws_region
  lb_port                     = var.lb_port
  target_group_arn            = module.target_group.target_group_arn
  security_groups_to_use      = local.security_group
  lb_type                     = var.lb_type
  lb_protocol                 = var.lb_protocol
  alb_cert_arn                = var.alb_cert_arn
  alb_ssl_policy              = var.alb_ssl_policy
}

module "securitygroup" {
  source                      = "git::git@github.com:tomarv2/terraform-aws-securitygroup.git?ref=0.0.1"

  email                       = var.email
  teamid                      = var.teamid
  prjid                       = var.prjid
  profile_to_use              = var.profile_to_use
  aws_region                  = var.aws_region
}


module "cloudwatch_sidecar" {
  source                      = "git::git@github.com:tomarv2/terraform-aws-cloudwatch.git?ref=0.0.1"

  cloudwatch_path             = var.cloudwatch_path
  email                       = var.email
  teamid                      = var.teamid
  prjid                       = var.prjid
  log_group_name              = "${var.teamid}-${var.prjid}-sidecar"
  aws_region                  = var.aws_region
  profile_to_use              = var.profile_to_use
}

module "target_group_sidecar" {
  source                      = "git::git@github.com:tomarv2/terraform-aws-target-group.git?ref=0.0.1"

  email                       = var.email
  teamid                      = var.teamid
  prjid                       = "${var.prjid}-sidecar"
  account_id                  = var.account_id
  profile_to_use              = var.profile_to_use
  aws_region                  = var.aws_region
  lb_protocol                 = var.lb_protocol_sidecar
  lb_port                     = var.lb_port_sidecar
  healthcheck_path            = var.healthcheck_path_sidecar
  healthy_threshold           = var.healthy_threshold_sidecar
  healthcheck_matcher         = var.healthcheck_matcher_sidecar
  healthcheck_timeout         = var.healthcheck_timeout_sidecar
  unhealthy_threshold         = var.unhealthy_threshold_sidecar
  healthcheck_interval        = var.healthcheck_interval_sidecar
}

module "lb_sidecar" {
  source                      = "git::git@github.com:tomarv2/terraform-aws-lb.git?ref=0.0.1"

  email                       = var.email
  teamid                      = var.teamid
  prjid                       = "${var.prjid}-sidecar"
  account_id                  = var.account_id
  profile_to_use              = var.profile_to_use
  aws_region                  = var.aws_region
  lb_port                     = var.lb_port_sidecar
  target_group_arn            = module.target_group_sidecar.target_group_arn
  security_groups_to_use      = local.security_group
  lb_type                     = var.lb_type
  lb_protocol                 = var.lb_protocol_sidecar
  alb_cert_arn                = var.alb_cert_arn_sidecar
  alb_ssl_policy              = var.alb_ssl_policy_sidecar
}

locals {
  shared_tags  = map(
      "Name", "${var.teamid}-${var.prjid}",
      "Owner", var.email,
      "Team", var.teamid,
      "Project", var.prjid
  )
}
