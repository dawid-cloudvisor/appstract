output "cluster_id" {
  description = "ID of the DocumentDB cluster"
  value       = aws_docdb_cluster.main.id
}

output "cluster_resource_id" {
  description = "Resource ID of the DocumentDB cluster"
  value       = aws_docdb_cluster.main.cluster_resource_id
}

output "endpoint" {
  description = "Endpoint of the DocumentDB cluster"
  value       = aws_docdb_cluster.main.endpoint
}

output "reader_endpoint" {
  description = "Reader endpoint of the DocumentDB cluster"
  value       = aws_docdb_cluster.main.reader_endpoint
}

output "port" {
  description = "Port of the DocumentDB cluster"
  value       = aws_docdb_cluster.main.port
}

output "security_group_id" {
  description = "ID of the security group for the DocumentDB cluster"
  value       = aws_security_group.docdb.id
}

output "instance_ids" {
  description = "IDs of the DocumentDB instances"
  value       = aws_docdb_cluster_instance.main[*].id
}

output "credentials_secret_arn" {
  description = "ARN of the Secrets Manager secret containing DocumentDB credentials"
  value       = aws_secretsmanager_secret.docdb_credentials.arn
}
