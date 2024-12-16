# variable "s3_bucket_name" {
#   description = "Name of the S3 bucket for Terraform state"
#   type        = string
# }

# variable "dynamodb_table_name" {
#   description = "Name of the DynamoDB table for state locking"
#   type        = string
# }

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
