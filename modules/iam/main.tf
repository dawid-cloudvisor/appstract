################################################################################
# IAM Roles for ECS
################################################################################

# ECS Task Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.environment}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Attach the Amazon ECS Task Execution Role policy
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach policy for Secrets Manager access
resource "aws_iam_role_policy" "ecs_execution_secrets_policy" {
  name = "${var.environment}-ecs-execution-secrets-policy"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "kms:Decrypt"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Policy for CloudWatch Logs
resource "aws_iam_role_policy" "ecs_task_cloudwatch_policy" {
  name = "${var.environment}-ecs-task-cloudwatch-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Policy for S3 access
resource "aws_iam_role_policy" "ecs_task_s3_policy" {
  name = "${var.environment}-ecs-task-s3-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.environment}-*/*",
          "arn:aws:s3:::${var.environment}-*"
        ]
      }
    ]
  })
}

################################################################################
# IAM Groups for Users
################################################################################

# Admin Group
resource "aws_iam_group" "admin" {
  name = "${var.environment}-admin"
}

resource "aws_iam_group_policy_attachment" "admin_policy" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# PowerUser Group
resource "aws_iam_group" "power_user" {
  name = "${var.environment}-power-user"
}

resource "aws_iam_group_policy_attachment" "power_user_policy" {
  group      = aws_iam_group.power_user.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# ReadOnly Group
resource "aws_iam_group" "read_only" {
  name = "${var.environment}-read-only"
}

resource "aws_iam_group_policy_attachment" "read_only_policy" {
  group      = aws_iam_group.read_only.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

################################################################################
# IAM Password Policy
################################################################################

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 12
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 24
}
