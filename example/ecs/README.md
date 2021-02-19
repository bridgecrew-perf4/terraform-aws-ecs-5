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
| app\_count | Number of docker containers to run | `number` | `1` | no |
| app\_image | Docker image to run in the ECS cluster | `any` | n/a | yes |
| app\_port | Port exposed by the docker image to redirect traffic to | `any` | n/a | yes |
| aws\_region | The AWS region to create things in. | `string` | `"us-east-2"` | no |
| az\_count | Number of AZs to cover in a given AWS region | `string` | `"2"` | no |
| container\_defination | n/a | `any` | n/a | yes |
| dns\_name | n/a | `any` | n/a | yes |
| ecs\_role | n/a | `any` | n/a | yes |
| email | Team email, not individual email. Cannot be changed after running 'tf apply'. | `any` | n/a | yes |
| iam\_instance\_profile\_to\_use | IAM role to be used by instance | `any` | n/a | yes |
| is\_production | n/a | `string` | `"false"` | no |
| key\_name | The SSH key name | `any` | n/a | yes |
| master\_role\_arn | n/a | `any` | n/a | yes |
| prjid | Name of the project/stack.  EG: mystack | `any` | n/a | yes |
| profile\_to\_use | Getting values from ~/.aws/credentials | `any` | n/a | yes |
| security\_groups\_to\_use | Security groups to use | `any` | n/a | yes |
| service\_ports | n/a | `any` | n/a | yes |
| teamid | Name of the team or group e.g. devops, dataengineering. Should not be changed after running 'tf apply'. | `any` | n/a | yes |
| type\_of\_record | n/a | `any` | n/a | yes |
| user\_data | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling\_group\_name | The name of the autoscaling group for the ECS container instances. |
| cluster\_arn | The ARN of the created ECS cluster. |
| cluster\_id | The ID of the created ECS cluster. |
| cluster\_name | The name of the created ECS cluster. |
| key\_used | n/a |
| launch\_configuration\_name | The name of the launch configuration for the ECS container instances. |
| log\_group | The name of the default log group for the cluster. |
| security\_group\_id | The ID of the default security group associated with the ECS container instances. |

## ToDo

- Adjust to work with Fargate