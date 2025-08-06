variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DocumentDB cluster"
  type        = list(string)
}

variable "documentdb_name" {
  description = "Name of the DocumentDB cluster"
  type        = string
}

variable "documentdb_version" {
  description = "Version of DocumentDB"
  type        = string
  default     = "4.0.0"
}

variable "documentdb_instance_class" {
  description = "Instance class for DocumentDB"
  type        = string
  default     = "db.t3.medium"
}

variable "documentdb_instance_count" {
  description = "Number of instances in the DocumentDB cluster"
  type        = number
  default     = 1
}

variable "security_group_ids" {
  description = "List of security group IDs to allow access to DocumentDB"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
