output "cluster_name" {
  description = "The name of the created ECS cluster."
  value = module.ecs.cluster_name
}

output "cluster_arn" {
  description = "The ARN of the created ECS cluster."
  value = module.ecs.cluster_arn
}

output "ecs_service_name" {
  description = "The name of the created ECS service."
  value = module.ecs.ecs_service_name
}

output "autoscaling_group_name" {
  description = "The name of the autoscaling group for the ECS container instances."
  value = module.ecs.autoscaling_group_name
}

output "launch_configuration_name" {
  description = "The name of the launch configuration for the ECS container instances."
  value = module.ecs.launch_configuration_name
}

output "security_group_id" {
  description = "The ID of the default security group associated with the ECS container instances."
  value = module.ecs.security_group_id
}

output "log_group" {
  description = "The name of the default log group for the cluster."
  value = module.ecs.log_group
}

output "key_used" {
  value = module.ecs.key_used
}

output "target_group_arn" {
  value = module.ecs.target_group_arn
}

output "task_definition_arn" {
  value = module.ecs.task_definition_arn
}
