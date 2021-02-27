variable "email" {
  description = "email address to be used for tagging (suggestion: use group email address)"
}

variable "teamid" {
  description = "(Required) Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
}

variable "prjid" {
  description = "(Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
}

variable "key_name" {
  description = "The SSH key name (NOTE: key should pre-exist)"
}

variable "profile_to_use" {
  description = "Getting values from ~/.aws/credentials"
}

variable "iam_instance_profile_to_use" {
  description = "IAM instance profile"
}

variable "security_groups_to_use" {
  description = "Security groups to use"
  default     = null
}

variable "aws_region" {
  description = "The AWS region to create resources"
  default     = "us-west-2"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "container_image" {
  description = "Docker image to run in the ECS cluster"
}

variable "container_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = [80]
}

variable "task_instance_count" {
  description = "The number of instances of the task definition to place and keep running."
  default     = 1
}

variable "dns_name" {
  default = ""
}

variable "type_of_record" {
  default = "A"
}

variable "account_id" {}

variable "task_role_arn" {
  default     = ""
  description = "The short name or full Amazon Resource Name (ARN) of the IAM role that containers in this task can assume"
}

variable "secrets" {
  default     = []
  description = "The secrets to pass to the container"
  type        = list(map(string))
}

variable "privileged" {
  type        = string
  description = "When this variable is `true`, the container is given elevated privileges on the host container instance (similar to the root user). This parameter is not supported for Windows containers or tasks using the Fargate launch type."
  default     = false
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

variable "healthcheck" {
  default     = {}
  description = "The health check command and associated configuration parameters for the container"
  type        = any
}

variable "log_configuration" {
  default = {}
  type    = any
}

variable "deploy_route53" {
  default = false
}

variable "volumes" {
  default     = []
  description = "A list of volume definitions in JSON format that containers in your task may use"
  type        = list(any)
}

variable "placement_constraints" {
  default     = []
  description = "An array of placement constraint objects to use for the task"
  type        = list(any)
}

variable "inst_type" {
  default     = "t2.medium"
  description = "The AWS instance type"
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

variable "port_mappings" {
  type    = list(any)
  default = []
}

variable "readonly_root_filesystem" {
  default = true
}

variable "family" {
  default = ""
}

variable "alb_ssl_policy" {
  default = ""
}

variable "alb_cert_arn" {
  default = ""
}

variable "memory_reservation" {
  default = ""
}

variable "container_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = ""
}

variable "container_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = ""
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

variable "repository_credentials" {
  default     = {}
  description = "The private repository authentication credentials to use"
  type        = map(string)
}

variable "network_mode" {
  default = ""
}

variable "pid_mode" {
  default = ""
}

variable "execution_role_arn" {
  default = ""
}

variable "essential" {
  default = true
}

variable "lb_protocol" {
  default = "TCP"
}

variable "stickiness" {
  type = object({
    cookie_duration = number
    enabled         = bool
  })
  description = "Target group sticky configuration"
  default     = null
}

variable "lb_type" {
  description = "load balancer type (network or application"
  default     = "network"
}

variable "healthcheck_path" {
  default = ""
}

variable "healthcheck_matcher" {
  default = ""
}

variable "healthcheck_timeout" {
  default = ""
}

variable "healthcheck_interval" {
  default = ""
}

variable "healthy_threshold" {
  description = "target group healthcheck threshold"
  default     = ""
}

variable "unhealthy_threshold" {
  description = "target group unheathy healthcheck threshold"
  default     = ""
}

variable "user_data_file_path" {
  description = "ec2 user data location"
  default     = "scripts/userdata.sh"
}

variable "lb_port" {
  default = [80]
}
