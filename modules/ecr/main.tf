################################################################################
# ECR Repositories
################################################################################

resource "aws_ecr_repository" "service" {
  count = length(var.service_names)

  name                 = "${var.environment}-${var.service_names[count.index]}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.service_names[count.index]}"
    }
  )
}

################################################################################
# ECR Repository Policies
################################################################################

resource "aws_ecr_lifecycle_policy" "service" {
  count = length(var.service_names)

  repository = aws_ecr_repository.service[count.index].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
