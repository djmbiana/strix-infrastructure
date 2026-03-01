terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}


provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "strix-tf-state-v1"

  tags = {
    Name = "S3 Bucket for Remote State"
    Purpose = "Terraform Backend"
    ManagedBy = "TF Bootstrap"
  }
}

resource "aws_s3_bucket_versioning" "tf_state_bucket_version" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = "strix-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name      = "Terraform State Lock Table"
    Purpose   = "Backend"
    ManagedBy = "TF Bootstrap"
  }
}
