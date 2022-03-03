module "global" {
  source = "git::git@github.com:tomarv2/terraform-global.git//aws?ref=v0.0.1"
}

module "route53" {
  source = "git::git@github.com:tomarv2/terraform-aws-route53.git?ref=v0.0.7"

  deploy_route53 = var.deploy_route53

  account_id       = local.account_info
  aws_region       = local.override_aws_region
  domain_name      = var.domain_name
  types_of_records = var.types_of_records
  names            = var.names
  values           = [module.lb.lb_dns_name]
  ttls             = var.ttls
  teamid           = var.teamid
  prjid            = var.prjid
}

module "cloudwatch" {
  source = "git::git@github.com:tomarv2/terraform-aws-cloudwatch.git?ref=v0.0.7"

  deploy_cloudwatch = var.deploy_cloudwatch

  cloudwatch_path = var.cloudwatch_path
  teamid          = var.teamid
  prjid           = var.prjid
}

module "ec2" {
  source = "git::git@github.com:tomarv2/terraform-aws-ec2.git?ref=v0.0.5"

  deploy_ec2 = var.key_name != null && var.launch_type != "FARGATE" ? true : false

  teamid               = var.teamid
  prjid                = var.prjid
  key_name             = var.key_name
  account_id           = local.account_info
  aws_region           = local.override_aws_region
  iam_instance_profile = var.iam_instance_profile
  security_groups      = local.security_groups
  image_id             = module.global.ecs_ami[local.account_info][local.override_aws_region]
  inst_type            = var.inst_type
  user_data_file_path  = var.user_data_file_path != null ? var.user_data_file_path : null
}

module "target_group" {
  source = "git::git@github.com:tomarv2/terraform-aws-target-group.git?ref=v0.0.5"

  deploy_target_group = var.deploy_target_group

  teamid               = var.teamid
  prjid                = var.prjid
  account_id           = local.account_info
  aws_region           = local.override_aws_region
  lb_protocol          = var.target_group_protocol != null ? var.target_group_protocol : var.lb_protocol
  lb_port              = var.target_group_port != null ? var.target_group_port : var.lb_port
  healthcheck_path     = var.healthcheck_path
  healthy_threshold    = var.healthy_threshold
  healthcheck_matcher  = var.healthcheck_matcher
  healthcheck_timeout  = var.healthcheck_timeout
  unhealthy_threshold  = var.unhealthy_threshold
  healthcheck_interval = var.healthcheck_interval
  target_type          = var.launch_type == "FARGATE" ? "ip" : "instance"
}

module "lb" {
  source = "git::git@github.com:tomarv2/terraform-aws-lb.git?ref=v0.0.6"

  deploy_lb = var.deploy_lb

  teamid           = var.teamid
  prjid            = var.prjid
  account_id       = local.account_info
  aws_region       = local.override_aws_region
  lb_port          = var.lb_port
  target_group_arn = module.target_group.target_group_arn
  security_groups  = local.security_groups
  lb_type          = var.lb_type
  lb_protocol      = var.lb_protocol
  alb_cert_arn     = var.alb_cert_arn
  alb_ssl_policy   = var.alb_ssl_policy
}

module "security_group" {
  source = "git::git@github.com:tomarv2/terraform-aws-security-group.git?ref=v0.0.6"

  deploy_security_group = var.deploy_security_group

  account_id             = local.account_info
  aws_region             = local.override_aws_region
  security_group_ingress = var.security_group_ingress
  security_group_egress  = var.security_group_egress
  #-------------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
