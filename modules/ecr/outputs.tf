output "repository_urls" {
  description = "URLs of the ECR repositories"
  value       = { for i, name in var.service_names : name => aws_ecr_repository.service[i].repository_url }
}

output "repository_arns" {
  description = "ARNs of the ECR repositories"
  value       = { for i, name in var.service_names : name => aws_ecr_repository.service[i].arn }
}

output "repository_names" {
  description = "Names of the ECR repositories"
  value       = { for i, name in var.service_names : name => aws_ecr_repository.service[i].name }
}
