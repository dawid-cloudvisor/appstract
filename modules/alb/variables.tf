variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
  default     = ""
}

variable "service_configs" {
  description = "Configuration for services"
  type = list(object({
    name              = string
    port              = number
    health_check_path = string
    path_patterns     = list(string)
  }))
  default = [
    {
      name              = "service1"
      port              = 80
      health_check_path = "/"
      path_patterns     = ["/api/service1/*"]
    },
    {
      name              = "service2"
      port              = 80
      health_check_path = "/"
      path_patterns     = ["/api/service2/*"]
    },
    {
      name              = "service3"
      port              = 80
      health_check_path = "/"
      path_patterns     = ["/api/service3/*"]
    },
    {
      name              = "service4"
      port              = 80
      health_check_path = "/"
      path_patterns     = ["/api/service4/*"]
    }
  ]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
