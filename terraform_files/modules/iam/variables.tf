# modules/iam/variables.tf
variable "common_tags" {
  description = "Common tags for resources in the IAM module"
  type        = map(string)
}
