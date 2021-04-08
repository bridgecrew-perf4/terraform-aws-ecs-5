output "cluster_name" {
  description = "The name of the created ECS cluster."
  type        = string
  value       = aws_ecs_cluster.ecs_cluster.name

}

output "cluster_arn" {
  description = "The ARN of the created ECS cluster."
  type        = string
  value       = aws_ecs_cluster.ecs_cluster.arn
}

output "ecs_service_name" {
  description = "The name of the created ECS service."
  type        = string
  value       = aws_ecs_service.ecs_service.name
}

output "autoscaling_group_name" {
  description = "The name of the autoscaling group for the ECS container instances."
  type        = string
  value       = module.ec2.autoscaling_group_name
}

output "launch_configuration_name" {
  description = "The name of the launch configuration for the ECS container instances."

  type  = string
  value = module.ec2.launch_configuration_name
}

output "security_group_id" {
  description = "The ID of the default security group associated with the ECS container instances."
  type        = string
  value       = module.security_group.security_group_id
}

output "log_group" {
  description = "The name of the default log group for the cluster."
  type        = string
  value       = module.cloudwatch.log_group
}

output "key_used" {
  value       = module.ec2.key_used
  type        = string
  description = "The key used to create the resources"
}

output "target_group_arn" {
  type  = string
  value = module.target_group.target_group_arn
}

output "task_definition_arn" {
  description = "The full Amazon Resource Name (ARN) of the task definition"
  type        = string
  value       = join("", aws_ecs_task_definition.ecs_task.*.arn)
}

output "container_definitions" {
  description = "A list of container definitions in JSON format that describe the different containers that make up your task"
  type        = list(any)
  value       = local.container_definitions
}

output "lb_sidecar" {

  type  = string
  value = module.lb_sidecar.lb_listener
}
