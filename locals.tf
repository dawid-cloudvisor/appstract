# Common tags for all resources
locals {
  common_tags = {
    Project     = "Appstract"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}