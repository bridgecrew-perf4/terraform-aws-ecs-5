variable "email" {
  description = "email address to be used for tagging (suggestion: use group email address)"
}
variable "teamid" {
  description = "(Required) Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
}

variable "prjid" {
  description = "(Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
}

variable "account_id" {
  description = "(Required) AWS account id (used to pull values from shared base module like vpc info, subnet ids)"
}

variable "profile_to_use" {
  description = "Getting values from ~/.aws/credentials"
  default     = "default"
}

variable "key_name" {
  description = "The SSH key name (NOTE: key should pre-exist)"
}

variable "iam_instance_profile_to_use" {
  description = "IAM instance profile"
}

variable "security_groups_to_use" {
  description = "existing security groups to use"
  default     = null
}

variable "security_group_ports" {
  default = [80]
}


variable "aws_region" {
  description = "aws region to create resources"
  default     = "us-west-2"
}

variable "az_count" {
  description = "Number of AZs to cover in a given aws region"
  default     = "2"
}

variable "container_image" {
  description = "Docker image to run in the ecs cluster"
}

variable "container_port" {
  description = "port exposed by the docker image to redirect traffic to"
  default     = [80]
}

variable "task_instance_count" {
  description = "number of instances of the task definition to place and keep running."
  default     = 1
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

variable "asg_min" {
  default     = 1
  description = "minimum number of instances for the autoscaling group"
}

variable "asg_desired" {
  default     = 1
  description = "desired number of instances for the autoscaling group"
}

variable "asg_max" {
  default     = 1
  description = "maximum number of instances for the autoscaling group"
}

variable "asg_cooldown" {
  default     = "300"
  description = "time between a scaling activity and the succeeding scaling activity"
}

variable "asg_health_check_type" {
  default     = "EC2"
  description = "can be EC2 or ELB"
}

variable "asg_health_grace_period" {
  default     = 600
  description = "How long to wait for instance to come up and start doing health checks"
}

variable "root_volume_type" {
  default     = "gp2"
  description = "can be standard or gp2"
}

variable "root_volume_size" {
  default     = 30
  description = "In gigabytes, must be at least 8"
}

variable "spot-instance-price" {
  default     = ""
  description = "Set to blank to use on-demand pricing"
}

variable "inst_type" {
  default     = "t2.medium"
  description = "aws instance type"
}

variable "launch_type" {
  default     = "EC2"
  description = "(Optional) The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2"
}

variable "efs_to_mount" {
  description = "(Optional) EFS to mount for persistent storage"
  default     = ""
}

variable "dns_name" {
  description = "(Optional) DNS name"
  default     = ""
}

variable "type_of_record" {
  description = "(Optional) type of DNS record"
  default     = "A"
}

variable "ttl" {
  description = "(Optional) DNS timeout"
  default     = "300"
}

variable "force_delete" {
  description = "forcefully delete asg"
  default     = "true"
}

variable "enable_monitoring" {
  description = "enable monitoring of launch configuration"
  default     = "false"
}


variable "associate_public_ip" {
  description = "associate public ip launch configuration"
  default     = "true"
}

variable "create_before_destroy" {
  description = "lifecycle for asg"
  default     = true
  type        = bool
}

variable "deployment_maximum_percent" {
  default = "100"
}

variable "deployment_minimum_healthy_percent" {
  default = "0"
}

variable "evaluate_target_health" {
  description = "evaluate route53 health"
  default     = true
  type        = bool
}

variable "deploy_route53" {
  description = "feature flag, true or false"
  default     = false
  type        = bool
}

variable "cloudwatch_path" {
  description = "name of the log group"
  default     = "ecs"
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
  description = "volume to mount to ecs container"
  type = list(object({
    name      = string
    host_path = string
  }))
  default = []
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
}

variable "readonly_root_filesystem" {
  description = "read only root filesystem"
  default     = true
}

variable "memory_reservation" {
  description = "The soft limit (in MiB) of memory to reserve for the container. When system memory is under contention, Docker attempts to keep the container memory to this soft limit"
  default     = ""
}

variable "container_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = ""
}

variable "container_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = ""
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
}

variable "alb_cert_arn" {
  description = "alb cert arn"
  default     = ""
}

variable "family" {
  description = "(Required) A unique name for your task definition"
  default     = ""
}

variable "execution_role_arn" {
  description = "The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
  default     = ""
}

variable "task_role_arn" {
  default     = ""
  description = "The short name or full Amazon Resource Name (ARN) of the IAM role that containers in this task can assume"
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. When networkMode=awsvpc, the host ports and container ports in port mappings must match."
  default     = "bridge"
}

variable "pid_mode" {
  description = "The process namespace to use for the containers in the task. The valid values are host and task"
  default     = ""
}

variable "healthcheck_path" {
  description = "target group healthcheck path"
  default     = ""
}

variable "healthy_threshold" {
  description = "target group healthcheck threshold"
  default     = ""
}

variable "healthcheck_matcher" {
  description = "healthcheck matcher (e.g. 200)"
  default     = ""
}

variable "healthcheck_timeout" {
  description = "target group healthcheck timeout"
  default     = ""
}

variable "healthcheck_interval" {
  description = "target group healthcheck interval"
  default     = ""
}

variable "unhealthy_threshold" {
  description = "target group unheathy healthcheck threshold"
  default     = ""
}

variable "is_public" {
  description = "is the resource public"
  default     = "false"
}

variable "lb_type" {
  description = "load balancer type (network or application"
  default     = ""
}

variable "lb_protocol" {
  description = "type of load balancer (e.g. HTTP, TCP, etc)"
  default     = ""
}

variable "lb_action_type" {
  description = "load balancer action type"
  default     = "forward"
}

variable "port_mappings" {
  description = "host to container port mapping"
  type        = list(any)
  default     = []
}

variable "container_networking_mode" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host"
  default     = "awsvpc"
}

variable "essential" {
  default = "true"
}

variable "propagate_tags" {
  default     = "SERVICE"
  description = " (Optional) Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION."
}

variable "user_data_file_path" {
  description = "ec2 user data location"
  default     = "scripts/userdata.sh"
}

variable "lb_port" {
  default = [80]
}

variable "scheduling_strategy" {
  description = "Scheduling strategy to use for the service. The valid values are REPLICA and DAEMON."
  default     = "REPLICA"
}

variable "capacity_providers" {
  description = "List of short names of one or more capacity providers to associate with the cluster. Valid values also include FARGATE and FARGATE_SPOT."
  default     = []
}

variable "deployment_controller_type" {
  default = "ECS"
}

variable "health_check_grace_period_seconds" {
  default = 10
}

variable "assign_public_ip" {
  default = false
}

variable "target_type" {
  default = "instance"
}

variable "deploy_ec2" {
  description = "feature flag, true or false"
  default     = false
  type        = bool
}

variable "container_insights" {
  description = "Controls if ECS Cluster has container insights enabled"
  type        = bool
  default     = false
}