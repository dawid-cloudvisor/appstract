terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # This will be configured per environment
  # backend "s3" {
  #   bucket         = "appstract-terraform-state"
  #   key            = "terraform.tfstate"
  #   region         = "eu-central-1"
  #   dynamodb_table = "appstract-terraform-locks"
  #   encrypt        = true
  # }
}
