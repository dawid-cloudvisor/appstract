################################################################################
# DocumentDB Cluster
################################################################################

resource "aws_docdb_subnet_group" "main" {
  name       = "${var.environment}-docdb-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-docdb-subnet-group"
    }
  )
}

resource "aws_security_group" "docdb" {
  name        = "${var.environment}-docdb-sg"
  description = "Security group for DocumentDB cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = var.security_group_ids
    description     = "Allow MongoDB traffic from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-docdb-sg"
    }
  )
}

resource "aws_docdb_cluster_parameter_group" "main" {
  family      = "docdb4.0"
  name        = "${var.environment}-docdb-parameter-group"
  description = "DocumentDB parameter group for ${var.environment}"

  parameter {
    name  = "tls"
    value = "enabled"
  }

  tags = var.tags
}

resource "aws_docdb_cluster" "main" {
  cluster_identifier              = "${var.environment}-${var.documentdb_name}"
  engine                          = "docdb"
  engine_version                  = var.documentdb_version
  master_username                 = "docdbadmin"
  master_password                 = "temporarypassword123!" # This will be changed and stored in Secrets Manager
  db_subnet_group_name            = aws_docdb_subnet_group.main.name
  vpc_security_group_ids          = [aws_security_group.docdb.id]
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name
  storage_encrypted               = true
  deletion_protection             = true
  skip_final_snapshot             = false
  final_snapshot_identifier       = "${var.environment}-${var.documentdb_name}-final-snapshot"
  backup_retention_period         = 7
  preferred_backup_window         = "02:00-04:00"
  preferred_maintenance_window    = "sun:04:00-sun:06:00"

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.documentdb_name}"
    }
  )
}

resource "aws_docdb_cluster_instance" "main" {
  count              = var.documentdb_instance_count
  identifier         = "${var.environment}-${var.documentdb_name}-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = var.documentdb_instance_class

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.documentdb_name}-${count.index + 1}"
    }
  )
}

################################################################################
# Store credentials in Secrets Manager
################################################################################

resource "aws_secretsmanager_secret" "docdb_credentials" {
  name        = "${var.environment}/documentdb/credentials"
  description = "DocumentDB credentials for ${var.environment} environment"

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "docdb_credentials" {
  secret_id = aws_secretsmanager_secret.docdb_credentials.id
  secret_string = jsonencode({
    username = "docdbadmin"
    password = "temporarypassword123!" # This should be changed after deployment
    host     = aws_docdb_cluster.main.endpoint
    port     = 27017
    dbname   = var.documentdb_name
  })
}
