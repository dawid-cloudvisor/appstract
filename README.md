# Appstract AWS Infrastructure

This repository contains Terraform Infrastructure as Code (IaC) for deploying Appstract's AWS infrastructure. The infrastructure is designed to support the migration from Azure to AWS, focusing on containerized services running on ECS Fargate.

## Overview

**Purpose**: Provision and manage AWS infrastructure for Appstract application migration from Azure to AWS.

**Key Features**:
- 3-tier VPC architecture with high availability
- ECS Fargate-based containerized services
- DocumentDB for MongoDB-compatible database
- Application Load Balancer with HTTPS termination
- Comprehensive security with IAM roles and Secrets Manager
- Multi-environment support (dev/prod)

**Target Audience**: DevOps engineers, Infrastructure teams, Appstract development team

## System Architecture

### Architecture Overview
The infrastructure follows AWS Well-Architected Framework principles with:

1. **Networking**: 3-tier VPC (public, private, database subnets) across multiple AZs
2. **Compute**: ECS Fargate for containerized workloads
3. **Storage**: S3 buckets for static assets, DocumentDB for application data
4. **Security**: IAM roles, security groups, Secrets Manager for sensitive data
5. **Load Balancing**: Application Load Balancer with SSL/TLS termination
6. **Monitoring**: CloudWatch integration for logs and metrics

### Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Internet Gateway                      │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                   Public Subnets                           │
│  ┌─────────────────┐              ┌─────────────────┐      │
│  │      ALB        │              │   Bastion Host  │      │
│  └─────────────────┘              └─────────────────┘      │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                  Private Subnets                           │
│  ┌─────────────────┐              ┌─────────────────┐      │
│  │   ECS Fargate   │              │   ECS Services  │      │
│  │    Cluster      │              │                 │      │
│  └─────────────────┘              └─────────────────┘      │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                 Database Subnets                           │
│  ┌─────────────────┐                                       │
│  │   DocumentDB    │                                       │
│  │    Cluster      │                                       │
│  └─────────────────┘                                       │
└─────────────────────────────────────────────────────────────┘
```

### Third-party Dependencies
- **Terraform**: Infrastructure provisioning (>= 1.0.0)
- **AWS Provider**: AWS resource management
- **DocumentDB**: MongoDB-compatible database service
- **ECS Fargate**: Serverless container platform

### Hosting Details
- **Cloud Provider**: Amazon Web Services (AWS)
- **Region**: eu-central-1 (Frankfurt)
- **Availability Zones**: Multi-AZ deployment for high availability

## Project Structure

```
appstract/
├── modules/                  # Reusable Terraform modules
│   ├── alb/                  # Application Load Balancer module
│   ├── bastion/              # Bastion host module
│   ├── documentdb/           # DocumentDB module
│   ├── ecr/                  # ECR repositories module
│   ├── ecs/                  # ECS cluster and services module
│   ├── iam/                  # IAM roles and policies module
│   ├── s3/                   # S3 buckets module
│   ├── secrets-manager/      # Secrets Manager module
│   └── vpc/                  # VPC and networking module
├── environments/             # Environment-specific configurations
│   ├── dev/                  # Development environment
│   └── prod/                 # Production environment
├── backend/                  # Terraform backend setup scripts
│   └── bootstrap.sh          # Creates S3 bucket and DynamoDB table
├── main.tf                   # Main Terraform configuration
├── variables.tf              # Input variables
├── outputs.tf                # Output values
├── providers.tf              # Provider configuration
├── backend.tf                # Backend configuration
├── LICENSE                   # License file
├── NOTICE                    # Third-party notices
└── README.md                 # This file
```

## Installation/Setup

### Prerequisites

- **Terraform**: Version 1.0.0 or later
- **AWS CLI**: Configured with appropriate credentials
- **Permissions**: AWS IAM permissions for creating VPC, ECS, DocumentDB, ALB, and related resources

### Initial Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd appstract
   ```

2. **Set up Terraform backend** (first-time setup):
   ```bash
   cd backend
   chmod +x bootstrap.sh
   ./bootstrap.sh
   cd ..
   ```

3. **Configure variables**:
   - Copy `terraform.tfvars.example` to `terraform.tfvars` (if available)
   - Update variables according to your environment requirements

## Deployment

### Environment-specific Deployment

1. **Navigate to target environment**:
   ```bash
   cd environments/dev  # or environments/prod
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan the deployment**:
   ```bash
   terraform plan
   ```

4. **Apply the changes**:
   ```bash
   terraform apply
   ```

### Deployment Order
The modules are designed with proper dependencies, but the typical deployment order is:
1. VPC and networking components
2. IAM roles and policies
3. Security groups
4. ECR repositories
5. DocumentDB cluster
6. ECS cluster and services
7. Application Load Balancer
8. Bastion host (if required)

## Configuration

### Environment Variables
Key configuration parameters are managed through Terraform variables:

- `environment`: Target environment (dev/prod)
- `region`: AWS region for deployment
- `availability_zones`: List of AZs to use
- `vpc_cidr`: CIDR block for VPC
- `app_name`: Application name for resource naming

### Secrets Management
Sensitive data is managed through AWS Secrets Manager:
- Database credentials
- API keys
- SSL certificates

## Testing

### Infrastructure Testing
- Use `terraform plan` to validate configuration changes
- Use `terraform validate` to check syntax
- Consider using `terratest` for automated infrastructure testing

### Security Testing
- Run `tfsec` for security scanning (if applicable)
- Review IAM policies for least privilege access
- Validate security group rules

## Maintenance

### Regular Maintenance Tasks
- Monitor AWS costs and resource utilization
- Update Terraform provider versions
- Review and rotate secrets in Secrets Manager
- Update container images in ECR
- Monitor CloudWatch logs and metrics

### Backup and Recovery
- Terraform state is stored in S3 with versioning enabled
- DocumentDB automated backups are configured
- ECS services can be quickly recreated from container images

### Scaling Considerations
- ECS services support auto-scaling based on CPU/memory utilization
- DocumentDB can be scaled vertically by changing instance types
- ALB automatically handles traffic distribution

## Modules Documentation

### VPC Module
Creates a 3-tier VPC with public, private, and database subnets across multiple availability zones.

### ECR Module
Creates ECR repositories for container images with scan-on-push enabled and lifecycle policies.

### IAM Module
Creates IAM roles and policies for ECS tasks, with least privilege access principles.

### S3 Module
Creates S3 buckets for static files with appropriate security settings and encryption.

### DocumentDB Module
Creates a DocumentDB cluster compatible with MongoDB, with automated backups and encryption.

### ALB Module
Creates an Application Load Balancer with HTTPS support and path-based routing capabilities.

### ECS Module
Creates an ECS cluster and services with auto-scaling capabilities and CloudWatch integration.

### Bastion Module
Creates a bastion host for secure SSH access to resources in private subnets.

### Secrets Manager Module
Creates Secrets Manager secrets for storing sensitive data with automatic rotation support.

## Changelog

### Version 1.0.0 (Initial Release)
- Initial infrastructure setup for Appstract AWS migration
- Multi-environment support (dev/prod)
- Complete ECS Fargate-based architecture
- DocumentDB integration
- Security best practices implementation

## License & Legal

This Terraform code is provided exclusively for use by Appstract. Redistribution, resale, or use in other projects without written permission is prohibited.

Copyright © 2025 Cloudvisor.
