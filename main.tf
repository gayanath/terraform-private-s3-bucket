resource "aws_s3_bucket" "this" {
  provider = aws.this
  bucket   = var.bucket_name
}

resource "aws_s3_bucket_acl" "this" {
  provider = aws.this
  bucket   = aws_s3_bucket.this.id
  acl      = "private"
}

resource "aws_s3_bucket_public_access_block" "this" {
  provider = aws.this
  bucket   = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count    = var.default_encryption_enabled ? 1 : 0
  provider = aws.this
  bucket   = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count    = var.versioning_enabled ? 1 : 0
  provider = aws.this
  bucket   = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count    = var.lifecycle_enabled ? 1 : 0
  provider   = aws.this
  depends_on = [aws_s3_bucket_versioning.this]

  bucket = aws_s3_bucket.this.id

  rule {
    id = "Rule-1"

    noncurrent_version_transition {
      noncurrent_days = 2
      storage_class   = "GLACIER_IR"
    }

    status = "Enabled"
  }
}
