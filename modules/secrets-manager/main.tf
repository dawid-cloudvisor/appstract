################################################################################
# Secrets Manager
################################################################################

# Create a secret for each service
resource "aws_secretsmanager_secret" "service" {
  count = length(var.service_names)

  name        = "${var.environment}/${var.service_names[count.index]}/secrets"
  description = "Secrets for ${var.service_names[count.index]} in ${var.environment} environment"

  tags = merge(
    var.tags,
    {
      Name    = "${var.environment}-${var.service_names[count.index]}-secrets"
      Service = var.service_names[count.index]
    }
  )
}

# Create initial secret versions with placeholder values
resource "aws_secretsmanager_secret_version" "service" {
  count = length(var.service_names)

  secret_id = aws_secretsmanager_secret.service[count.index].id
  secret_string = jsonencode({
    # Placeholder values - should be updated after deployment
    API_KEY       = "placeholder-api-key"
    DB_CONNECTION = "placeholder-db-connection"
  })
}
