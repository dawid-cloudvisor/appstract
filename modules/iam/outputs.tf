output "ecs_execution_role_arn" {
  description = "ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_execution_role_name" {
  description = "Name of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.name
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_role_name" {
  description = "Name of the ECS task role"
  value       = aws_iam_role.ecs_task_role.name
}

output "admin_group_name" {
  description = "Name of the admin group"
  value       = aws_iam_group.admin.name
}

output "power_user_group_name" {
  description = "Name of the power user group"
  value       = aws_iam_group.power_user.name
}

output "read_only_group_name" {
  description = "Name of the read-only group"
  value       = aws_iam_group.read_only.name
}
