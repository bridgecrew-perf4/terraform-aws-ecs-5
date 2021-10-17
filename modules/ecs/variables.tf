variable "teamid" {
  description = "(Required) Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
  type        = string
}

variable "prjid" {
  description = "(Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
  type        = string
}

variable "account_id" {
  description = "(Required) AWS account id (used to pull values from shared base module like vpc info, subnet ids)"
  type        = string
}

variable "profile_to_use" {
  description = "Getting values from ~/.aws/credentials"
  default     = "default"
  type        = string
}

variable "key_name" {
  description = "The SSH key name (NOTE: key should pre-exist)"
  type        = string
  default     = null
}

variable "iam_instance_profile_to_use" {
  description = "IAM instance profile"
  type        = string
  default     = null
}

variable "security_groups_to_use" {
  description = "existing security groups to use"
  default     = null
  type        = string
}

variable "aws_region" {
  description = "aws region to create resources"
  default     = "us-west-2"
  type        = string
}
/*
variable "az_count" {
  description = "Number of AZs to cover in a given aws region"
  default     = "2"
  type        = string
}
*/
variable "container_image" {
  description = "Docker image to run in the ecs cluster"
  type        = string
}

variable "container_port" {
  description = "port exposed by the docker image to redirect traffic to"
  default     = [80]
  type        = list(any)
}

variable "task_instance_count" {
  description = "number of instances of the task definition to place and keep running."
  default     = 1
  type        = number
}

variable "task_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = null
  type        = string
}

variable "task_memory" {
  description = "Instance memory to provision (in MiB)"
  type        = number
  default     = 512
}

/*
variable "asg_min" {
  default     = 1
  description = "minimum number of instances for the autoscaling group"
  type        = number
}

variable "asg_desired" {
  default     = 1
  description = "desired number of instances for the autoscaling group"
  type        = number
}

variable "asg_max" {
  default     = 1
  description = "maximum number of instances for the autoscaling group"
  type        = number
}

variable "asg_cooldown" {
  default     = "300"
  description = "time between a scaling activity and the succeeding scaling activity"
  type        = string
}

variable "asg_health_check_type" {
  default     = "EC2"
  description = "can be EC2 or ELB"
  type        = string
}

variable "asg_health_grace_period" {
  default     = 600
  description = "How long to wait for instance to come up and start doing health checks"
  type        = number
}
*/
/*
variable "root_volume_type" {
  default     = "gp2"
  description = "can be standard or gp2"
  type        = string
}
*/
/*
variable "root_volume_size" {
  default     = 30
  description = "In gigabytes, must be at least 8"
  type        = number
}
*/
/*
variable "spot-instance-price" {
  default     = ""
  description = "Set to blank to use on-demand pricing"
  type        = string
}
*/
variable "inst_type" {
  default     = "t2.medium"
  description = "aws instance type"
  type        = string
}

variable "launch_type" {
  default     = "EC2"
  description = "(Optional) The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2"
  type        = string
}

variable "deploy_route53" {
  description = "feature flag, true or false"
  default     = false
  type        = bool
}

variable "domain_name" {
  description = "(Optional) DNS name"
  default     = ""
  type        = string
}

variable "ttls" {
  type        = list(any)
  default     = ["3600"]
  description = "(Required for non-alias records) The TTL of the record."
}

variable "names" {
  type        = list(any)
  default     = []
  description = "The name of the record."
}

variable "types_of_records" {
  type        = list(any)
  default     = []
  description = "The record type. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT. "
}

/*
variable "force_delete" {
  description = "forcefully delete asg"
  default     = "true"
  type        = string
}
*/
/*
variable "enable_monitoring" {
  description = "enable monitoring of launch configuration"
  default     = "false"
  type        = string
}
*/
/*
variable "associate_public_ip" {
  description = "associate public ip launch configuration"
  default     = "true"
  type        = string
}
*/
/*
variable "create_before_destroy" {
  description = "lifecycle for asg"
  default     = true
  type        = bool
}
*/
variable "deployment_maximum_percent" {
  description = "Deployment maximum percent"
  default     = "100"
  type        = string
}

variable "deployment_minimum_healthy_percent" {
  description = "Deployment minimum healthy percent"
  default     = "0"
  type        = string
}

variable "cloudwatch_path" {
  description = "name of the log group"
  default     = "ecs"
  type        = string
}

variable "entrypoint" {
  default     = []
  description = "The entry point that is passed to the container"
  type        = list(any)
}

variable "command" {
  default     = []
  description = "The command that is passed to the container"
  type        = list(string)
}

variable "privileged" {
  type        = string
  description = "When this variable is `true`, the container is given elevated privileges on the host container instance (similar to the root user). This parameter is not supported for Windows containers or tasks using the Fargate launch type. Due to how Terraform type casts booleans in json it is required to double quote this value"
  default     = false
}

# https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_HealthCheck.html
variable "healthcheck" {
  default     = {}
  description = "The health check command and associated configuration parameters for the container"
  type        = any
}
/*
  variable "healthcheck" {
    type = object({
      command     = list(string)
      retries     = number
      timeout     = number
      interval    = number
      startPeriod = number
    })
    description = "A map containing command (string), timeout, interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy), and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries)"
    default     = null
  }
*/

variable "log_configuration" {
  description = "ecs log group configuration"
  default     = {}
  type        = any
}

variable "volumes" {
  description = "A set of volume blocks that containers in your task may use"
  type = list(object({
    host_path = string
    name      = string
    docker_volume_configuration = list(object({
      autoprovision = bool
      driver        = string
      driver_opts   = map(string)
      labels        = map(string)
      scope         = string
    }))
    efs_volume_configuration = list(object({
      file_system_id          = string
      root_directory          = string
      transit_encryption      = string
      transit_encryption_port = string
      authorization_config = list(object({
        access_point_id = string
        iam             = string
      }))
    }))
  }))
  default = [
    /*
        {
          host_path = null,
          name      = ""
          docker_volume_configuration = [{
            autoprovision = null
            driver        = null
            driver_opts   = null
            labels        = null
            scope         = null
          }]
          efs_volume_configuration = [{
            file_system_id          = null
            root_directory          = null
            transit_encryption      = null
            transit_encryption_port = ""
            authorization_config = [{
              access_point_id = ""
              iam             = ""
            }]
          }]
        }*/
  ]
}

variable "placement_constraints" {
  description = "(Optional) A set of placement constraints rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10."
  type = list(object({
    type       = string
    expression = string
  }))
  default = []
}

variable "environment" {
  default     = []
  description = "The environment variables to pass to the container. This is a list of maps"
  type        = list(map(string))
}
/*
variable "environment_files" {
  type = list(object({
    value = string
    type  = string
  }))
  description = "One or more files containing the environment variables to pass to the container. This maps to the --env-file option to docker run. The file must be hosted in Amazon S3. This option is only available to tasks using the EC2 launch type. This is a list of maps"
  default     = null
}
*/
variable "mount_points" {
  type        = list(any)
  description = "Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional."
  default     = []
}

variable "register_task_definition" {
  default     = true
  type        = bool
  description = "Registers a new task definition from the supplied family and containerDefinitions"
}

variable "readonly_root_filesystem" {
  description = "read only root filesystem"
  default     = true
  type        = bool
}

variable "memory_reservation" {
  description = "The soft limit (in MiB) of memory to reserve for the container. When system memory is under contention, Docker attempts to keep the container memory to this soft limit"
  default     = ""
  type        = string
}

variable "container_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = ""
  type        = string
}

variable "container_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = ""
  type        = string
}

variable "repository_credentials" {
  default     = {}
  description = "The private repository authentication credentials to use"
  type        = map(string)
}

variable "secrets" {
  default     = []
  description = "The secrets to pass to the container"
  type        = list(map(string))
}

variable "alb_ssl_policy" {
  description = "alb ssl policy"
  default     = ""
  type        = string
}

variable "alb_cert_arn" {
  description = "alb cert arn"
  default     = ""
  type        = string
}

variable "family" {
  description = "(Required) A unique name for your task definition"
  default     = ""
  type        = string
}

variable "execution_role_arn" {
  description = "The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
  default     = ""
  type        = string
}

variable "task_role_arn" {
  default     = ""
  description = "The short name or full Amazon Resource Name (ARN) of the IAM role that containers in this task can assume"
  type        = string
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. When networkMode=awsvpc, the host ports and container ports in port mappings must match."
  default     = "bridge"
  type        = string
}

variable "pid_mode" {
  description = "The process namespace to use for the containers in the task. The valid values are host and task"
  default     = ""
  type        = string
}

variable "healthcheck_path" {
  description = "target group healthcheck path"
  default     = ""
  type        = string
}

variable "healthy_threshold" {
  description = "target group healthcheck threshold"
  default     = ""
  type        = string
}

variable "healthcheck_matcher" {
  description = "healthcheck matcher (e.g. 200)"
  default     = ""
  type        = string
}

variable "healthcheck_timeout" {
  description = "target group healthcheck timeout"
  default     = ""
  type        = string
}

variable "healthcheck_interval" {
  description = "target group healthcheck interval"
  default     = ""
  type        = string
}

variable "unhealthy_threshold" {
  description = "target group unheathy healthcheck threshold"
  default     = ""
  type        = string
}
/*
variable "is_public" {
  description = "is the resource public"
  default     = "false"
  type        = string
}
*/
variable "lb_type" {
  description = "load balancer type (network or application"
  default     = ""
  type        = string
}

variable "lb_protocol" {
  description = "type of load balancer (e.g. HTTP, TCP, etc)"
  default     = ""
  type        = string
}
/*
variable "lb_action_type" {
  description = "load balancer action type"
  default     = "forward"
  type        = string
}
*/
variable "port_mappings" {
  description = "host to container port mapping"
  type        = list(any)
  default     = []
}
/*
variable "container_networking_mode" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host"
  default     = "awsvpc"
  type        = string
}
*/
variable "essential" {
  description = "Essential"
  default     = "true"
  type        = string
}

variable "propagate_tags" {
  default     = "SERVICE"
  description = " (Optional) Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION."
  type        = string
}

variable "user_data_file_path" {
  description = "ec2 user data location"
  default     = null
  type        = string
}

variable "lb_port" {
  description = "Load balancer type"
  default     = [80]
  type        = list(any)
}

variable "scheduling_strategy" {
  description = "Scheduling strategy to use for the service. The valid values are REPLICA and DAEMON."
  default     = "REPLICA"
  type        = string
}
/*
variable "capacity_providers" {
  description = "List of short names of one or more capacity providers to associate with the cluster. Valid values also include FARGATE and FARGATE_SPOT."
  default     = []
  type        = list(any)
}
*/
variable "deployment_controller_type" {
  description = "Deployment container type"
  default     = "ECS"
  type        = string
}

variable "health_check_grace_period_seconds" {
  description = "Health check grace period"
  default     = 10
  type        = number
}
/*
variable "target_type" {
  default = "instance"
  type    = string
}
*/
/*
variable "deploy_ec2" {
  description = "feature flag, true or false"
  default     = false
  type        = bool
}
*/
variable "container_insights" {
  description = "Controls if ECS Cluster has container insights enabled"
  type        = bool
  default     = false
}

variable "security_group_ingress" {
  description = "Can be specified multiple times for each ingress rule. "
  type = map(object({
    description = string
    from_port   = number
    protocol    = string
    type        = string
    to_port     = number
    self        = bool
    cidr_blocks = list(string)
  }))
  default = {
    default = {
      description = "HTTP"
      from_port   = 80
      protocol    = "tcp"
      type        = "ingress"
      to_port     = 80
      self        = true
      cidr_blocks = []
    }
  }
}

variable "security_group_egress" {
  description = "Can be specified multiple times for each egress rule. "
  type = map(object({
    description = string
    from_port   = number
    protocol    = string
    type        = string
    to_port     = number
    self        = bool
    cidr_blocks = list(string)
  }))
  default = {
    default = {
      description = "Allow All Outbound"
      from_port   = 0
      protocol    = "-1"
      type        = "egress"
      to_port     = 0
      self        = false
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "target_group_port" {
  description = "target group ports"
  default     = null
  type        = list(number)
}

variable "target_group_protocol" {
  description = "type of load balancer (e.g. HTTP, TCP, etc)"
  default     = null
  type        = string
}

variable "assign_public_ip" {
  description = "Assign public IP"
  default     = false
  type        = bool
}

variable "deploy_ec2" {
  description = "feature flag, true or false"
  default     = false
  type        = bool
}

variable "deploy_cloudwatch" {
  description = "feature flag, true or false"
  default     = true
  type        = bool
}

variable "deploy_lb" {
  description = "feature flag, true or false"
  default     = true
  type        = bool
}

variable "deploy_security_group" {
  description = "feature flag, true or false"
  default     = true
  type        = bool
}

variable "deploy_target_group" {
  description = "feature flag, true or false"
  default     = true
  type        = bool
}

variable "deploy_ecs" {
  description = "feature flag, true or false"
  default     = true
  type        = bool
}
