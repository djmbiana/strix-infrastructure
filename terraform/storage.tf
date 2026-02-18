resource "aws_s3_bucket" "strix_scans" {
  bucket = "strix-git-log-scans"

  tags = {
    Name = "strix-git-log-scans"
  }
}

resource "aws_s3_bucket_versioning" "strix_scans_versioning" {
  bucket = aws_s3_bucket.strix_scans.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "strix_scans_block" {
  bucket = aws_s3_bucket.strix_scans.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "strix_db" {
  name = "strix-scan-db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "repository"
  range_key = "scannedAt"

  attribute {
    name = "repository"
    type = "S"
  }

  attribute {
    name = "scannedAt"
    type = "S"
  }

  tags = {
    Name = "dynamodb-table-strix"
  }
}
