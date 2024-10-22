provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "prem_tf_state_s3" {
  bucket = "prem-tf-state-s3"

  #prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }
}
#enable versioning
resource "aws_s3_bucket_versioning" "prem_tf_state_s3_ver" {
  bucket = aws_s3_bucket.prem_tf_state_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

# enable SSL by default
resource "aws_s3_bucket_server_side_encryption_configuration" "prem_tf_state_s3_ssl" {
  bucket = aws_s3_bucket.prem_tf_state_s3.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#block all public access to s3
resource "aws_s3_bucket_public_access_block" "prem_tf_state_s3_access" {
  bucket = aws_s3_bucket.prem_tf_state_s3.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "prem_tf_state_lock_dyna" {
  name = "prem-tf-state-lock-dyna"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}