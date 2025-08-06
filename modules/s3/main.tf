################################################################################
# S3 Buckets
################################################################################

resource "aws_s3_bucket" "bucket" {
  count = length(var.bucket_names)

  bucket = var.bucket_names[count.index]

  tags = merge(
    var.tags,
    {
      Name = var.bucket_names[count.index]
    }
  )
}

# Block public access for all buckets
resource "aws_s3_bucket_public_access_block" "bucket" {
  count = length(var.bucket_names)

  bucket = aws_s3_bucket.bucket[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for all buckets
resource "aws_s3_bucket_versioning" "bucket" {
  count = length(var.bucket_names)

  bucket = aws_s3_bucket.bucket[count.index].id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for all buckets
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  count = length(var.bucket_names)

  bucket = aws_s3_bucket.bucket[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
