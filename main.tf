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
