variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "bucket_names" {
  description = "List of S3 bucket names to create"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
