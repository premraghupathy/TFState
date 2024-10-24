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

terraform {
  backend "s3" {
    bucket = "prem-tf-state-s3"
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "prem-tf-state-lock-dyna"
    encrypt = true
  }
}

output "prem_tf_state_s3_arn" {
  value = aws_s3_bucket.prem_tf_state_s3.arn
  description = "Prem TF state S3 ARN"
}

output "prem_tf_state_dynamodb_table_name" {
  value = aws_dynamodb_table.prem_tf_state_lock_dyna.name
  description = "Prem TF state lock dynamodb table name"
}
// EOF for TF state using TF backend

/** 
* Isolation using Workspaces
* The below blocks are for TF state using TF workspaces
*/
resource "aws_instance" "prem_tf_workspace-ec2" {
  instance_type="t2.micro"
  ami="ami-0e86e20dae9224db8"
  subnet_id="subnet-04edb3ea22236883e"
}

terraform {
  backend "s3" {
    bucket = "prem-tf-state-s3"
    key = "workspaces/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "prem-tf-state-lock-dyna"
    encrypt = true
  }
}