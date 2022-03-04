variable "teamid" {
  description = "Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
  type        = string
}

variable "prjid" {
  description = "Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
  type        = string
}

variable "key_name" {
  description = "The SSH key name (NOTE: key should pre-exist)"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM instance profile"
  type        = string
  default     = null
}

variable "security_groups" {
  description = "Existing Security groups to use"
  default     = null
  type        = string
}

variable "region" {
  description = "The AWS region to create resources"
  default     = null
  type        = string
}

variable "container_image" {
  description = "Docker image to run in the ECS cluster"
  type        = string
}

variable "container_port" {
  description = "List of container port exposed by the docker image to redirect traffic to"
  default     = [80]
  type        = list(any)
}

variable "task_instance_count" {
  description = "The number of instances of the task definition to place and keep running"
  default     = 1
  type        = any
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
  description = "Feature flag, true or false"
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
  default     = []
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

variable "cloudwatch_path" {
  description = "name of the log group"
  default     = "/ecs"
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

variable "environment_files" {
  type = list(object({
    value = string
    type  = string
  }))
  description = "One or more files containing the environment variables to pass to the container. This maps to the --env-file option to docker run. The file must be hosted in Amazon S3. This option is only available to tasks using the EC2 launch type. This is a list of maps"
  default     = null
}

variable "mount_points" {
  type        = list(any)
  description = "Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional."
  default     = []
}

variable "register_task_definition" {
  default     = true
  description = "Registers a new task definition from the supplied family and containerDefinitions"
  type        = bool
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
  description = "A unique name for your task definition"
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
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host."
  default     = ""
  type        = string
}

variable "pid_mode" {
  description = "The process namespace to use for the containers in the task. The valid values are host and task"
  default     = ""
  type        = string
}

variable "port_mappings" {
  description = "host to container port mapping"
  type        = list(any)
  default     = []
}

variable "essential" {
  description = "Essential"
  default     = "true"
  type        = string
}

# container 2 config
variable "entrypoint_sidecar" {
  default     = []
  description = "The entry point that is passed to the container"
  type        = list(any)
}

variable "command_sidecar" {
  default     = []
  description = "The command that is passed to the container"
  type        = list(string)
}

variable "privileged_sidecar" {
  type        = string
  description = "When this variable is `true`, the container is given elevated privileges on the host container instance (similar to the root user). This parameter is not supported for Windows containers or tasks using the Fargate launch type. Due to how Terraform type casts booleans in json it is required to double quote this value"
  default     = false
}

# https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_HealthCheck.html
variable "healthcheck_sidecar" {
  default     = {}
  description = "The health check command and associated configuration parameters for the container"
  type        = any
}

variable "repository_credentials_sidecar" {
  default     = {}
  description = "The private repository authentication credentials to use"
  type        = map(string)
}

variable "secrets_sidecar" {
  default     = []
  description = "The secrets to pass to the container"
  type        = list(map(string))
}

variable "environment_sidecar" {
  default     = []
  description = "The environment variables to pass to the container. This is a list of maps"
  type        = list(map(string))
}
variable "port_mappings_sidecar" {
  description = "host to container port mapping"
  type        = list(any)
  default     = []
}

variable "container_port_sidecar" {
  description = "Container port sidecar"
  default     = [80]
  type        = list(any)
}

variable "log_configuration_sidecar" {
  description = "Log configuration sidecar"
  default     = {}
  type        = any
}

variable "mount_points_sidecar" {
  type        = list(any)
  description = "Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional."
  default     = []
}

variable "memory_reservation_sidecar" {
  description = "The soft limit (in MiB) of memory to reserve for the container. When system memory is under contention, Docker attempts to keep the container memory to this soft limit"
  default     = ""
  type        = string
}

variable "container_memory_sidecar" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = ""
  type        = string
}

variable "container_cpu_sidecar" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = ""
  type        = string
}

variable "readonly_root_filesystem_sidecar" {
  description = "Read only root filesystem sidecar"
  default     = true
  type        = bool
}

variable "container_image_sidecar" {
  description = "Docker image to run in the ECS cluster"
  type        = string
}

variable "network_mode_sidecar" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host."
  default     = ""
  type        = string
}

variable "essential_sidecar" {
  description = "Essential sidecar"
  default     = "true"
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

variable "unhealthy_threshold" {
  description = "target group unheathy healthcheck threshold"
  default     = ""
  type        = string
}

variable "lb_type" {
  description = "load balancer type (network or application"
  default     = ""
  type        = string
}

variable "lb_protocol" {
  description = "type of load balancer (e.g. HTTP, TCP, etc"
  default     = ""
  type        = string
}

variable "account_id" {
  description = "AWS account id (used to pull values from shared base module like vpc info, subnet ids)"
  type        = string
  default     = null
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

variable "healthcheck_path_sidecar" {
  description = "Healthcheck path sidecar"
  type        = string
}

variable "healthcheck_matcher_sidecar" {
  description = "Healthcheck matcher sidecar"
  type        = string
}

variable "healthcheck_timeout_sidecar" {
  description = "Healthcheck timeout sidecar"
  type        = string
}

variable "healthcheck_interval_sidecar" {
  description = "Healthcheck internal sidecar"
  type        = string
}

variable "healthy_threshold_sidecar" {
  description = "target group healthcheck threshold"
  type        = string
}

variable "unhealthy_threshold_sidecar" {
  description = "target group unheathy healthcheck threshold"
  type        = string
}

variable "alb_ssl_policy_sidecar" {
  description = "Load balancer policy sidecar"
  default     = ""
  type        = string
}

variable "alb_cert_arn_sidecar" {
  description = "Load balancer cert arn"
  default     = ""
  type        = string
}

variable "lb_protocol_sidecar" {
  description = "Load balancer protocol"
  default     = "HTTP"
  type        = string
}

variable "lb_port" {
  description = "Load balancer port"
  default     = [80]
  type        = list(any)
}

variable "lb_port_sidecar" {
  description = "Load balancer port sidecar"
  default     = [80]
  type        = list(any)
}

variable "environment_files_sidecar" {
  type = list(object({
    value = string
    type  = string
  }))
  description = "One or more files containing the environment variables to pass to the container. This maps to the --env-file option to docker run. The file must be hosted in Amazon S3. This option is only available to tasks using the EC2 launch type. This is a list of maps"
  default     = null
}

variable "container_insights" {
  description = "Controls if ECS Cluster has container insights enabled"
  type        = bool
  default     = false
}

variable "assign_public_ip" {
  description = "Assign public IP"
  default     = false
  type        = bool
}

variable "deployment_controller_type" {
  description = "Controller type"
  default     = "ECS"
  type        = string
}

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

variable "scheduling_strategy" {
  description = "Scheduling strategy to use for the service. The valid values are REPLICA and DAEMON."
  default     = "REPLICA"
  type        = string
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
  type        = list(any)
}

variable "target_group_protocol" {
  description = "type of load balancer (e.g. HTTP, TCP, etc)"
  default     = null
  type        = string
}

variable "target_group_port_sidecar" {
  description = "target group ports"
  default     = null
  type        = list(any)
}

variable "target_group_protocol_sidecar" {
  description = "type of load balancer (e.g. HTTP, TCP, etc)"
  default     = null
  type        = string
}

variable "healthcheck_interval" {
  description = "target group healthcheck interval"
  default     = ""
  type        = string
}

variable "deploy_cloudwatch" {
  description = "Feature flag, true or false"
  default     = true
  type        = bool
}

variable "deploy_lb" {
  description = "Feature flag, true or false"
  default     = true
  type        = bool
}

variable "deploy_security_group" {
  description = "Feature flag, true or false"
  default     = true
  type        = bool
}

variable "deploy_target_group" {
  description = "Feature flag, true or false"
  default     = true
  type        = bool
}

variable "deploy_ecs" {
  description = "Feature flag, true or false"
  default     = true
  type        = bool
}
