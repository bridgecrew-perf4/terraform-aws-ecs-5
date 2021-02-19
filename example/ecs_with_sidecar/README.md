# AWS Elastic Container Service (ECS)

Terraform to create ECS resources on AWS.

## Pre-reqs:

- Email address to be used for tagging
- IAM instance profile (can be found on the IAM role)
- List of Security groups
- List of Subnets
- VPC id
- AWS account number
- Docker image
- Private key to be used by EC2

## How to use:

- Clone `_module/ecs/scripts/container-defination-rumse-demo-ecs.json` file and make required changes. Name of the file
should match the project and team id format.
e.g. if your project name is `web` and team name is `infra`, then
the file name should be `container-defination-infra-web.json`

- Clone `_module/ecs/scripts/userdata-rumse-demo-ecs.sh` and make the required changes.

- Update `_module/ecs/_shared_cloudinit.tf` and either clone Section: 1,2, or 3 or you can append new sections below.
Check the files names. All environment variables that go inside containers are specified here.

This module focuses on [ECS](https://www.terraform.io/docs/providers/aws/r/ecs_cluster.html)

**NOTE:** In most cases creating resources is heavily opinionated and or context-bound. That is why this module does not create these resources.

## Terraform versions

Terraform 0.12 

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | n/a | `any` | n/a | yes |
| alb\_cert\_arn | n/a | `string` | `""` | no |
| alb\_protocol | n/a | `string` | `"HTTP"` | no |
| alb\_ssl\_policy | n/a | `string` | `""` | no |
| aws\_region | The AWS region to create resources | `string` | `"us-west-2"` | no |
| az\_count | Number of AZs to cover in a given AWS region | `string` | `"2"` | no |
| command | The command that is passed to the container | `list(string)` | `[]` | no |
| command\_sidecar | The command that is passed to the container | `list(string)` | `[]` | no |
| container\_cpu | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `string` | `""` | no |
| container\_cpu\_sidecar | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `string` | `""` | no |
| container\_image | Docker image to run in the ECS cluster | `any` | n/a | yes |
| container\_image\_sidecar | Docker image to run in the ECS cluster | `any` | n/a | yes |
| container\_memory | Fargate instance memory to provision (in MiB) | `string` | `""` | no |
| container\_memory\_sidecar | Fargate instance memory to provision (in MiB) | `string` | `""` | no |
| container\_port | List of container port exposed by the docker image to redirect traffic to | `list` | <pre>[<br>  80<br>]</pre> | no |
| container\_port\_sidecar | n/a | `any` | n/a | yes |
| deploy\_route53 | n/a | `bool` | `false` | no |
| dns\_name | n/a | `string` | `""` | no |
| email | email address to be used for tagging (suggestion: use group email address) | `any` | n/a | yes |
| entrypoint | The entry point that is passed to the container | `list` | `[]` | no |
| entrypoint\_sidecar | The entry point that is passed to the container | `list` | `[]` | no |
| environment | The environment variables to pass to the container. This is a list of maps | `list(map(string))` | `[]` | no |
| environment\_sidecar | The environment variables to pass to the container. This is a list of maps | `list(map(string))` | `[]` | no |
| essential | n/a | `bool` | `true` | no |
| essential\_sidecar | n/a | `bool` | `true` | no |
| execution\_role\_arn | n/a | `string` | `""` | no |
| family | n/a | `string` | `""` | no |
| healthcheck | The health check command and associated configuration parameters for the container | `any` | `{}` | no |
| healthcheck\_interval | n/a | `any` | n/a | yes |
| healthcheck\_matcher | n/a | `any` | n/a | yes |
| healthcheck\_path | n/a | `any` | n/a | yes |
| healthcheck\_sidecar | The health check command and associated configuration parameters for the container | `any` | `{}` | no |
| healthcheck\_timeout | n/a | `any` | n/a | yes |
| healthy\_threshold | target group healthcheck threshold | `any` | n/a | yes |
| iam\_instance\_profile\_to\_use | IAM instance profile | `any` | n/a | yes |
| inst\_type | The AWS instance type | `string` | `"t2.medium"` | no |
| key\_name | The SSH key name (NOTE: key should pre-exist) | `any` | n/a | yes |
| lb\_protocol | n/a | `string` | `"HTTP"` | no |
| lb\_type | load balancer type (network or application | `string` | `"network"` | no |
| log\_configuration | n/a | `any` | `{}` | no |
| log\_configuration\_sidecar | n/a | `any` | `{}` | no |
| memory\_reservation | n/a | `string` | `""` | no |
| memory\_reservation\_sidecar | n/a | `string` | `""` | no |
| mount\_points | Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional. | `list` | `[]` | no |
| mount\_points\_sidecar | Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional. | `list` | `[]` | no |
| network\_mode | n/a | `string` | `""` | no |
| network\_mode\_sidecar | n/a | `string` | `""` | no |
| pid\_mode | n/a | `string` | `""` | no |
| placement\_constraints | An array of placement constraint objects to use for the task | `list` | `[]` | no |
| port\_mappings | n/a | `list` | `[]` | no |
| port\_mappings\_sidecar | n/a | `list` | `[]` | no |
| privileged | When this variable is `true`, the container is given elevated privileges on the host container instance (similar to the root user). This parameter is not supported for Windows containers or tasks using the Fargate launch type. | `string` | `false` | no |
| privileged\_sidecar | When this variable is `true`, the container is given elevated privileges on the host container instance (similar to the root user). This parameter is not supported for Windows containers or tasks using the Fargate launch type. Due to how Terraform type casts booleans in json it is required to double quote this value | `string` | `false` | no |
| prjid | (Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| profile\_to\_use | Getting values from ~/.aws/credentials | `any` | n/a | yes |
| readonly\_root\_filesystem | n/a | `bool` | `true` | no |
| readonly\_root\_filesystem\_sidecar | n/a | `bool` | `true` | no |
| repository\_credentials | The private repository authentication credentials to use | `map(string)` | `{}` | no |
| repository\_credentials\_sidecar | The private repository authentication credentials to use | `map(string)` | `{}` | no |
| secrets | The secrets to pass to the container | `list(map(string))` | `[]` | no |
| secrets\_sidecar | The secrets to pass to the container | `list(map(string))` | `[]` | no |
| security\_groups\_to\_use | Existing Security groups to use | `any` | `null` | no |
| service\_ports | n/a | `list` | <pre>[<br>  "80",<br>  "443"<br>]</pre> | no |
| stickiness | Target group sticky configuration | <pre>object({<br>    cookie_duration = number<br>    enabled         = bool<br>  })</pre> | `null` | no |
| task\_cpu | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `string` | `256` | no |
| task\_cpu\_sidecar | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `string` | `256` | no |
| task\_instance\_count | The number of instances of the task definition to place and keep running. | `number` | `1` | no |
| task\_memory | n/a | `number` | `0` | no |
| task\_memory\_sidecar | n/a | `number` | `0` | no |
| task\_role\_arn | The short name or full Amazon Resource Name (ARN) of the IAM role that containers in this task can assume | `string` | `""` | no |
| teamid | (Required) Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| type\_of\_record | n/a | `string` | `"A"` | no |
| unhealthy\_threshold | target group unheathy healthcheck threshold | `any` | n/a | yes |
| volumes | A list of volume definitions in JSON format that containers in your task may use | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling\_group\_name | The name of the autoscaling group for the ECS container instances. |
| cluster\_arn | The ARN of the created ECS cluster. |
| cluster\_name | The name of the created ECS cluster. |
| ecs\_service\_name | The name of the created ECS service. |
| key\_used | n/a |
| launch\_configuration\_name | The name of the launch configuration for the ECS container instances. |
| log\_group | The name of the default log group for the cluster. |
| security\_group\_id | The ID of the default security group associated with the ECS container instances. |
| target\_group\_arn | n/a |
| task\_definition\_arn | n/a |
