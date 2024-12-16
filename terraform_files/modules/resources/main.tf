resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"

  tags = var.common_tags
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.common_tags
}
