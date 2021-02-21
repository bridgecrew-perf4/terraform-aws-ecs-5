# Terraform module for ECS

Note: This module is to create one ECS cluster with one task and container
## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | (Required) AWS account id (used to pull values from shared base module like vpc info, subnet ids) | `any` | n/a | yes |
| alb\_cert\_arn | alb cert arn | `string` | `""` | no |
| alb\_ssl\_policy | alb ssl policy | `string` | `""` | no |
| asg\_cooldown | time between a scaling activity and the succeeding scaling activity | `string` | `"300"` | no |
| asg\_desired | desired number of instances for the autoscaling group | `number` | `1` | no |
| asg\_health\_check\_type | can be EC2 or ELB | `string` | `"EC2"` | no |
| asg\_health\_grace\_period | How long to wait for instance to come up and start doing health checks | `number` | `600` | no |
| asg\_max | maximum number of instances for the autoscaling group | `number` | `1` | no |
| asg\_min | minimum number of instances for the autoscaling group | `number` | `1` | no |
| associate\_public\_ip | associate public ip launch configuration | `string` | `"true"` | no |
| aws\_region | aws region to create resources | `string` | `"us-west-2"` | no |
| az\_count | Number of AZs to cover in a given aws region | `string` | `"2"` | no |
| cloudwatch\_path | name of the log group | `string` | `"ecs"` | no |
| command | The command that is passed to the container | `list(string)` | `[]` | no |
| container\_cpu | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `string` | `""` | no |
| container\_image | Docker image to run in the ecs cluster | `any` | n/a | yes |
| container\_memory | Fargate instance memory to provision (in MiB) | `string` | `""` | no |
| container\_networking\_mode | The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host | `string` | `"awsvpc"` | no |
| container\_port | port exposed by the docker image to redirect traffic to | `list` | <pre>[<br>  80<br>]</pre> | no |
| create\_before\_destroy | lifecycle for asg | `bool` | `true` | no |
| deploy\_route53 | feature flag, true or false | `bool` | `false` | no |
| deployment\_maximum\_percent | n/a | `string` | `"100"` | no |
| deployment\_minimum\_healthy\_percent | n/a | `string` | `"0"` | no |
| dns\_name | (Optional) DNS name | `string` | `""` | no |
| efs\_to\_mount | (Optional) EFS to mount for persistent storage | `string` | `""` | no |
| email | email address to be used for tagging (suggestion: use group email address) | `any` | n/a | yes |
| enable\_monitoring | enable monitoring of launch configuration | `string` | `"false"` | no |
| entrypoint | The entry point that is passed to the container | `list` | `[]` | no |
| environment | The environment variables to pass to the container. This is a list of maps | `list(map(string))` | `[]` | no |
| environment\_files | One or more files containing the environment variables to pass to the container. This maps to the --env-file option to docker run. The file must be hosted in Amazon S3. This option is only available to tasks using the EC2 launch type. This is a list of maps | <pre>list(object({<br>    value = string<br>    type  = string<br>  }))</pre> | `null` | no |
| essential | n/a | `string` | `"true"` | no |
| evaluate\_target\_health | evaluate route53 health | `bool` | `true` | no |
| execution\_role\_arn | The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume. | `string` | `""` | no |
| family | (Required) A unique name for your task definition | `string` | `""` | no |
| force\_delete | forcefully delete asg | `string` | `"true"` | no |
| healthcheck | The health check command and associated configuration parameters for the container | `any` | `{}` | no |
| healthcheck\_interval | target group healthcheck interval | `string` | `""` | no |
| healthcheck\_matcher | healthcheck matcher (e.g. 200) | `string` | `""` | no |
| healthcheck\_path | target group healthcheck path | `string` | `""` | no |
| healthcheck\_timeout | target group healthcheck timeout | `string` | `""` | no |
| healthy\_threshold | target group healthcheck threshold | `string` | `""` | no |
| iam\_instance\_profile\_to\_use | IAM instance profile | `any` | n/a | yes |
| inst\_type | aws instance type | `string` | `"t2.medium"` | no |
| is\_public | is the resource public | `string` | `"false"` | no |
| key\_name | The SSH key name (NOTE: key should pre-exist) | `any` | n/a | yes |
| launch\_type | (Optional) The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2 | `string` | `"EC2"` | no |
| lb\_action\_type | load balancer action type | `string` | `"forward"` | no |
| lb\_port | n/a | `list` | <pre>[<br>  80<br>]</pre> | no |
| lb\_protocol | type of load balancer (e.g. HTTP, TCP, etc) | `string` | `""` | no |
| lb\_type | load balancer type (network or application | `string` | `""` | no |
| log\_configuration | ecs log group configuration | `any` | `{}` | no |
| memory\_reservation | The soft limit (in MiB) of memory to reserve for the container. When system memory is under contention, Docker attempts to keep the container memory to this soft limit | `string` | `""` | no |
| mount\_points | Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional. | `list` | `[]` | no |
| network\_mode | The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. | `string` | `""` | no |
| pid\_mode | The process namespace to use for the containers in the task. The valid values are host and task | `string` | `""` | no |
| placement\_constraints | (Optional) A set of placement constraints rules that are taken into consideration during task placement. Maximum number of placement\_constraints is 10. | <pre>list(object({<br>    type        = string<br>    expression   = string<br>  }))</pre> | n/a | yes |
| port\_mappings | host to container port mapping | `list` | `[]` | no |
| privileged | When this variable is `true`, the container is given elevated privileges on the host container instance (similar to the root user). This parameter is not supported for Windows containers or tasks using the Fargate launch type. Due to how Terraform type casts booleans in json it is required to double quote this value | `string` | `false` | no |
| prjid | (Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| profile\_to\_use | Getting values from ~/.aws/credentials | `string` | `"default"` | no |
| propagate\_tags | (Optional) Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK\_DEFINITION. | `string` | `"SERVICE"` | no |
| readonly\_root\_filesystem | read only root filesystem | `bool` | `true` | no |
| register\_task\_definition | Registers a new task definition from the supplied family and containerDefinitions | `bool` | `true` | no |
| repository\_credentials | The private repository authentication credentials to use | `map(string)` | `{}` | no |
| root\_volume\_size | In gigabytes, must be at least 8 | `number` | `30` | no |
| root\_volume\_type | can be standard or gp2 | `string` | `"gp2"` | no |
| secrets | The secrets to pass to the container | `list(map(string))` | `[]` | no |
| security\_groups\_to\_use | existing security groups to use | `any` | `null` | no |
| spot-instance-price | Set to blank to use on-demand pricing | `string` | `""` | no |
| task\_cpu | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `string` | `null` | no |
| task\_instance\_count | number of instances of the task definition to place and keep running. | `number` | `1` | no |
| task\_memory | Instance memory to provision (in MiB) | `number` | `512` | no |
| task\_role\_arn | The short name or full Amazon Resource Name (ARN) of the IAM role that containers in this task can assume | `string` | `""` | no |
| teamid | (Required) Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| ttl | (Optional) DNS timeout | `string` | `"300"` | no |
| type\_of\_record | (Optional) type of DNS record | `string` | `"A"` | no |
| unhealthy\_threshold | target group unheathy healthcheck threshold | `string` | `""` | no |
| user\_data\_file\_path | ec2 user data location | `string` | `"scripts/userdata.sh"` | no |
| volumes | volume to mount to ecs container | <pre>list(object({<br>    name        = string<br>    host_path   = string<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling\_group\_name | The name of the autoscaling group for the ECS container instances. |
| cluster\_arn | The ARN of the created ECS cluster. |
| cluster\_name | The name of the created ECS cluster. |
| container\_definitions | A list of container definitions in JSON format that describe the different containers that make up your task |
| ecs\_service\_name | The name of the created ECS service. |
| key\_used | The key used to create the resources |
| launch\_configuration\_name | The name of the launch configuration for the ECS container instances. |
| log\_group | The name of the default log group for the cluster. |
| security\_group\_id | The ID of the default security group associated with the ECS container instances. |
| target\_group\_arn | n/a |
| task\_definition\_arn | The full Amazon Resource Name (ARN) of the task definition |
