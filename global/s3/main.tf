
provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "terra-forma-borja-3001"
    # 1:1 mapeo organizacion directorios
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terra-forma-borja-3031-locks"
    encrypt        = true
  }

}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terra-forma-borja-3001"

  lifecycle {
    prevent_destroy = true

  }
}

# resource "aws_s3_bucket_versioning" "terraform_state"
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

  # resource "aws_s3_bucket_public_access_bloc" "public_access"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name     = "terra-forma-borja-3031-locks"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}
