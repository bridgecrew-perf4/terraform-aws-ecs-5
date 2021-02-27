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
  description = "Existing Security groups to use"
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
  description = "List of container port exposed by the docker image to redirect traffic to"
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

variable "service_ports" {
  default = ["80", "443"]
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
  description = "Fargate instance memory to provision (in MiB)"
  type        = number
  default     = null
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
  type    = list(any)
  default = []
}

variable "container_port_sidecar" {
}

variable "log_configuration_sidecar" {
  default = {}
  type    = any
}

variable "mount_points_sidecar" {
  type        = list(any)
  description = "Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional."
  default     = []
}

variable "memory_reservation_sidecar" {
  default = ""
}

variable "readonly_root_filesystem_sidecar" {
  default = true
}

variable "container_image_sidecar" {
  description = "Docker image to run in the ECS cluster"
}

variable "network_mode_sidecar" {
  default = ""
}

variable "container_memory_sidecar" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = ""
}

variable "container_cpu_sidecar" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = ""
}

variable "task_memory_sidecar" {
  default = 0
}

variable "task_cpu_sidecar" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 256
  type        = string
}

variable "essential_sidecar" {
  default = true
}

variable "lb_protocol" {
  default = "HTTP"
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

variable "healthcheck_path" {}

variable "healthcheck_matcher" {}

variable "healthcheck_timeout" {}

variable "healthcheck_interval" {}

variable "healthy_threshold" {
  description = "target group healthcheck threshold"
}

variable "unhealthy_threshold" {
  description = "target group unheathy healthcheck threshold"
}

variable "healthcheck_path_sidecar" {}

variable "healthcheck_matcher_sidecar" {}

variable "healthcheck_timeout_sidecar" {}

variable "healthcheck_interval_sidecar" {}

variable "healthy_threshold_sidecar" {
  description = "target group healthcheck threshold"
}

variable "unhealthy_threshold_sidecar" {
  description = "target group unheathy healthcheck threshold"
}

variable "alb_ssl_policy_sidecar" {
  default = ""
}

variable "alb_cert_arn_sidecar" {
  default = ""
}

variable "lb_protocol_sidecar" {
  default = "HTTP"
}

variable "lb_port" {
}

variable "lb_port_sidecar" {
  default = ""
}

variable "environment_files_sidecar" {
  type = list(object({
    value = string
    type  = string
  }))
  description = "One or more files containing the environment variables to pass to the container. This maps to the --env-file option to docker run. The file must be hosted in Amazon S3. This option is only available to tasks using the EC2 launch type. This is a list of maps"
  default     = null
}

variable "user_data_file_path" {}