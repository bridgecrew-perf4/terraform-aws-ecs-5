<p align="center">
    <a href="https://github.com/tomarv2/terraform-aws-ecs/actions/workflows/pre-commit.yml" alt="Pre Commit">
        <img src="https://github.com/tomarv2/terraform-aws-ecs/actions/workflows/pre-commit.yml/badge.svg?branch=main" /></a>
    <a href="https://www.apache.org/licenses/LICENSE-2.0" alt="license">
        <img src="https://img.shields.io/github/license/tomarv2/terraform-aws-ecs" /></a>
    <a href="https://github.com/tomarv2/terraform-aws-ecs/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-aws-ecs" /></a>
    <a href="https://github.com/tomarv2/terraform-aws-ecs/pulse" alt="Activity">
        <img src="https://img.shields.io/github/commit-activity/m/tomarv2/terraform-aws-ecs" /></a>
    <a href="https://stackoverflow.com/users/6679867/tomarv2" alt="Stack Exchange reputation">
        <img src="https://img.shields.io/stackexchange/stackoverflow/r/6679867"></a>
    <a href="https://twitter.com/intent/follow?screen_name=varuntomar2019" alt="follow on Twitter">
        <img src="https://img.shields.io/twitter/follow/varuntomar2019?style=social&logo=twitter"></a>
</p>

## Terraform module for [AWS ECS](https://aws.amazon.com/ecs)

> :arrow_right:  Terraform module for [Azure ACI](https://registry.terraform.io/modules/tomarv2/container-instance/azure/latest)
>
## ECS cluster requires

:point_right: An existing VPC (getting information from [terraform-global](https://github.com/tomarv2/terraform-global) module)

:point_right: Existing subnets (getting information from [terraform-global](https://github.com/tomarv2/terraform-global) module)

:point_right: Existing IAM role

## The module works both EC2 and Fargate

:point_right: Creates an ECS service with AWS load balancer.

:point_right: Stream logs to a CloudWatch log group.

:point_right: Associate multiple target groups with Network Load Balancers (NLB) and Application Load Balancers (ALB).

:point_right: Supports running ECS tasks on EC2 instances or Fargate.

:point_right: Container deploys nginx container on port 80

### Versions

- Module tested for Terraform 1.0.1.
- AWS provider version [3.74](https://registry.terraform.io/providers/hashicorp/aws/latest)
- `main` branch: Provider versions not pinned to keep up with Terraform releases.
- `tags` releases: Tags are pinned with versions (use <a href="https://github.com/tomarv2/terraform-aws-ecs/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-aws-ecs" /></a> ).

### Usage

#### Option 1:

```
terrafrom init
terraform plan -var='teamid=tryme' -var='prjid=project1'
terraform apply -var='teamid=tryme' -var='prjid=project1'
terraform destroy -var='teamid=tryme' -var='prjid=project1'
```
**Note:** With this option please take care of remote state storage

#### Option 2:

##### Recommended method (stores remote state in remote backend(S3,  Azure storage, or Google bucket) using `prjid` and `teamid` to create directory structure):

- Create python 3.8+ virtual environment
```
python3 -m venv <venv name>
```

- Install package:
```
pip install tfremote --upgrade
```

- Set below environment variables:
```
export TF_AWS_BUCKET=<remote state bucket name>
export TF_AWS_BUCKET_REGION=us-west-2
export TF_AWS_PROFILE=<profile from ~/.ws/credentials>
```

or

- Set below environment variables:
```
export TF_AWS_BUCKET=<remote state bucket name>
export TF_AWS_BUCKET_REGION=us-west-2
export AWS_ACCESS_KEY_ID=<aws_access_key_id>
export AWS_SECRET_ACCESS_KEY=<aws_secret_access_key>
```

- Updated `examples` directory with required values.

- Run and verify the output before deploying:
```
tf -c=aws plan -var='teamid=foo' -var='prjid=bar'
```

- Run below to deploy:
```
tf -c=aws apply -var='teamid=foo' -var='prjid=bar'
```

- Run below to destroy:
```
tf -c=aws destroy -var='teamid=foo' -var='prjid=bar'
```

**Note:** Read more on [tfremote](https://github.com/tomarv2/tfremote)
##### ECS (EC2 and Fargate)
```
provider "aws" {
  region = var.region
}

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


module "common" {
  source = "git::git@github.com:tomarv2/terraform-global.git//common?ref=v0.0.1"
}

module "ecs" {
  source = "../../modules/ecs"

  execution_role_arn       = "arn:aws:iam::123456789012:role/demo-role"
  task_role_arn            = "arn:aws:iam::123456789012:role/demo-role"
  lb_type                  = "application"
  readonly_root_filesystem = false
  privileged               = false
  # ---------------------------------------------
  # REQUIRED FOR EC2
  # ---------------------------------------------
  key_name             = "demo-key"
  iam_instance_profile = "arn:aws:iam::123456789012:instance-profile/demo-role-profile"
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
  log_configuration    = { logDriver = "awslogs", options = { awslogs-group = "/ecs/${var.teamid}-${var.prjid}", awslogs-region = var.region, awslogs-stream-prefix = "ecs" } }
  lb_protocol          = "HTTP"
  healthcheck_path     = "/"
  healthcheck_matcher  = "200"
  healthcheck_timeout  = "30"
  healthcheck_interval = "120"
  healthy_threshold    = "2"
  unhealthy_threshold  = "2"
  user_data_file_path  = "scripts/userdata.sh"
  # ---------------------------------------------
  # DNS
  # ---------------------------------------------
  deploy_route53   = true
  domain_name      = "dev.demo.com"
  names            = ["${var.teamid}-${var.prjid}"]
  types_of_records = ["CNAME"]
  # ----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
```

#### ECS with sidecar(EC2 and Fargate)
```
provider "aws" {
  region = var.region
}

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

module "common" {
  source = "git::git@github.com:tomarv2/terraform-global.git//common?ref=v0.0.1"
}

module "ecs" {
  source = "../../modules/ecs_with_sidecar"

  key_name                    = "demo-key"
  iam_instance_profile        = "arn:aws:iam::123456789012:instance-profile/demo-role-profile"
  execution_role_arn          = "arn:aws:iam::123456789012:role/demo-role"
  task_role_arn               = "arn:aws:iam::123456789012:role/demo-role"
  lb_type                     = "application"
  user_data_file_path         = "scripts/userdata.sh"
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
  launch_type        = "FARGATE"
  network_mode       = "awsvpc"
  task_cpu           = "512"
  task_memory        = "1024"
  assign_public_ip   = true
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
```

Please refer to examples directory [link](examples)


#### **Terraform list resources**

```
terraform state list

module.ecs.data.template_file.container_definition
module.ecs.aws_ecs_cluster.ecs_cluster
module.ecs.aws_ecs_service.ecs_service
module.ecs.aws_ecs_task_definition.ecs_task[0]
module.ecs.module.cloudwatch.aws_cloudwatch_log_group.cloudwatch
module.ecs.module.ec2_alb.data.template_cloudinit_config.cloudinit
module.ecs.module.ec2_alb.data.template_file.shell-script
module.ecs.module.ec2_alb.aws_alb.alb
module.ecs.module.ec2_alb.aws_alb_listener.listener
module.ecs.module.ec2_alb.aws_autoscaling_group.asg
module.ecs.module.ec2_alb.aws_launch_configuration.launchcfg
module.ecs.module.ec2_alb.aws_lb_target_group.alb_target_group
module.ecs.module.ec2_alb.module.securitygroup.aws_security_group.default
```

##### **Destroy one resource**
```
tf destroy -target module.ecs.module.ec2_alb.aws_launch_configuration.launchcfg -var='teamid=demo' -var='prjid=demo' -cloud aws
```
