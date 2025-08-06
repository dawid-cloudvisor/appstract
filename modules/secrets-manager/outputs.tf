output "secret_arns" {
  description = "ARNs of the Secrets Manager secrets"
  value       = { for i, name in var.service_names : name => aws_secretsmanager_secret.service[i].arn }
}

output "secret_names" {
  description = "Names of the Secrets Manager secrets"
  value       = { for i, name in var.service_names : name => aws_secretsmanager_secret.service[i].name }
}
