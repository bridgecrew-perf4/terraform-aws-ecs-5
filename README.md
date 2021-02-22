[![Unit Tests](https://github.com/tomarv2/terraform-aws-ecs/actions/workflows/unit_test.yml/badge.svg?branch=main)](https://github.com/tomarv2/terraform-aws-ecs/actions/workflows/unit_test.yml)
[![](https://img.shields.io/badge/license-Apache%202-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

# terraform-aws-ecs
Terraform module for [AWS ECS](https://www.terraform.io/docs/providers/aws/r/ecs_cluster.html)

## ECS cluster requires:

- An existing VPC (getting information from [terraform-global](https://github.com/tomarv2/terraform-global) module)
- Existing subnets (getting information from [terraform-global](https://github.com/tomarv2/terraform-global) module)
- Existing IAM role

## Module deploys below:

- Creates an ECS service with AWS load balancer.
- Stream logs to a CloudWatch log group.
- Associate multiple target groups with Network Load Balancers (NLB) and Application Load Balancers (ALB).
- Supports running ECS tasks on EC2 instances or Fargate.
- Container deploys nginx container on port 80

## For usage 

- **ECS:** Please refer to example directory [link](example/ecs/base/README.md)

- **ECS with Sidecar:** Please refer to example directory [link](example/ecs_with_sidecar/base/README.md)

## How to use?

Recommended method:

- Create python 3.6+ virtual environment 
```
python3 -m venv <venv name>
```

- Install package:
```
pip install tfremote
```

- Set below environment variables:
```
export TF_AWS_BUCKET=<remote state bucket name>
export TF_AWS_PROFILE=default
export TF_AWS_BUCKET_REGION=us-west-2
export PATH=$PATH:/usr/local/bin/
```  

- Update:
```
example/custom/sample.tfvars
```

- Following entries are required:

```
- account_id
- function_name
- role_arn
- source_file (relative path to the base directory or provide absolute path)
- output_file_path
- teamid
- prjid
```

- Change to: 
```
example/base
``` 

- Run and verify the output before deploying:
```
tf -cloud aws plan -var-file <path to .tfvars file>
```

- Run below to deploy:
```
tf -cloud aws apply -var-file <path to .tfvars file>
```

- Run below to destroy:
```
tf -cloud aws destroy -var-file <path to .tfvars file>
```

**NOTE:** 

- Read more on [tfremote](https://github.com/tomarv2/tfremote) 
- I will not be pinning the main branch to keep up with Terraform releases, for deployments please
use the latest tag versions which have versions pinned for stability.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | n/a | `any` | n/a | yes |
| alb\_action\_type | n/a | `string` | `"forward"` | no |
| alb\_is\_public | n/a | `string` | `"false"` | no |
| alb\_listener\_port | n/a | `string` | `"80"` | no |
| alb\_listener\_protocol | n/a | `string` | `"HTTP"` | no |
| alb\_target\_group\_port | n/a | `string` | `"80"` | no |
| alb\_target\_group\_protocol | n/a | `string` | `"HTTP"` | no |
| alb\_type | n/a | `string` | `"application"` | no |
| app\_count | Number of docker containers to run | `any` | n/a | yes |
| app\_cpu | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `number` | `256` | no |
| app\_image | Docker image to run in the ECS cluster | `any` | n/a | yes |
| app\_memory | Fargate instance memory to provision (in MiB) | `number` | `512` | no |
| app\_port | Port exposed by the docker image to redirect traffic to | `any` | n/a | yes |
| asg\_cooldown | time between a scaling activity and the succeeding scaling activity | `string` | `"300"` | no |
| asg\_desired | The desired number of instances for the autoscaling group | `number` | `1` | no |
| asg\_health\_check\_type | Can be EC2 or ELB | `string` | `"EC2"` | no |
| asg\_health\_grace\_period | How long to wait for instance to come up and start doing health checks | `number` | `600` | no |
| asg\_max | The maximum number of instances for the autoscaling group | `number` | `1` | no |
| asg\_min | The minimum number of instances for the autoscaling group | `number` | `1` | no |
| assoicate\_public\_ip | n/a | `string` | `"true"` | no |
| aws\_region | The AWS region to create things in. | `string` | `"us-east-2"` | no |
| az\_count | Number of AZs to cover in a given AWS region | `string` | `"2"` | no |
| cloudwatch\_path | n/a | `string` | `"ecs"` | no |
| container\_defination | n/a | `any` | n/a | yes |
| create\_before\_destroy | n/a | `bool` | `true` | no |
| deploy\_route53 | n/a | `bool` | `false` | no |
| deployment\_maximum\_percent | n/a | `string` | `"100"` | no |
| deployment\_minimum\_healthy\_percent | n/a | `string` | `"0"` | no |
| dns\_name | n/a | `any` | n/a | yes |
| ebs\_vol\_name | name of ebs volume | `string` | `"/dev/xvdh"` | no |
| ebs\_vol\_size | size of ebs volume | `string` | `"100"` | no |
| ebs\_vol\_type | type of ebs volume | `string` | `"gp2"` | no |
| ecs\_role | n/a | `any` | n/a | yes |
| efs\_to\_mount | n/a | `string` | `""` | no |
| email | Team email, not individual email. Cannot be changed after running 'tf apply'. | `any` | n/a | yes |
| enable\_monitoring | n/a | `string` | `"false"` | no |
| evaluate\_target\_health | n/a | `bool` | `true` | no |
| force\_delete | n/a | `string` | `"true"` | no |
| healthcheck\_interval | n/a | `string` | `"120"` | no |
| healthcheck\_matcher | n/a | `string` | `"200"` | no |
| healthcheck\_path | n/a | `string` | `"/healthcheck"` | no |
| healthcheck\_port | n/a | `string` | `"80"` | no |
| healthcheck\_retries | n/a | `number` | `2` | no |
| healthcheck\_start\_period | n/a | `number` | `120` | no |
| healthcheck\_timeout | n/a | `string` | `"30"` | no |
| healthy\_threshold | n/a | `string` | `"2"` | no |
| iam\_instance\_profile\_to\_use | IAM role to be used by instance | `any` | n/a | yes |
| inst\_type | The AWS instance type | `string` | `"t2.medium"` | no |
| is\_production | n/a | `string` | `"false"` | no |
| key\_name | The SSH key name | `any` | n/a | yes |
| launch\_type | The AWS instance type | `string` | `"EC2"` | no |
| master\_role\_arn | n/a | `any` | n/a | yes |
| os\_release | The AMI OS release. | `string` | `"test_ops_latest"` | no |
| os\_version | The AMI OS version. | `string` | `"Centos7X86_64"` | no |
| privileged | n/a | `string` | `"true"` | no |
| prjid | Name of the project/stack.  EG: mystack | `any` | n/a | yes |
| profile\_to\_use | Getting values from ~/.aws/credentials | `any` | n/a | yes |
| root\_volume\_size | In gigabytes, must be at least 8 | `number` | `30` | no |
| root\_volume\_type | Can be standard or gp2 | `string` | `"gp2"` | no |
| security\_groups\_to\_use | Security groups to use | `any` | n/a | yes |
| service\_ports | n/a | `any` | n/a | yes |
| spot-instance-price | Set to blank to use on-demand pricing | `string` | `""` | no |
| task\_cpu | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `number` | `256` | no |
| task\_memory | Fargate instance memory to provision (in MiB) | `number` | `512` | no |
| teamid | Name of the team or group e.g. devops, dataengineering. Should not be changed after running 'tf apply'. | `any` | n/a | yes |
| ttl | n/a | `string` | `"300"` | no |
| type\_of\_record | n/a | `any` | n/a | yes |
| unhealthy\_threshold | n/a | `string` | `"2"` | no |
| user\_data | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling\_group\_name | The name of the autoscaling group for the ECS container instances. |
| cluster\_arn | The ARN of the created ECS cluster. |
| cluster\_id | The ID of the created ECS cluster. |
| cluster\_name | The name of the created ECS cluster. |
| key\_used | The key used to create the resources |
| launch\_configuration\_name | The name of the launch configuration for the ECS container instances. |
| log\_group | The name of the default log group for the cluster. |
| security\_group\_id | The ID of the default security group associated with the ECS container instances. |

