provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "Appstract"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Provider for resources that must be created in us-east-1 (e.g., ACM certificates for CloudFront)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "Appstract"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
