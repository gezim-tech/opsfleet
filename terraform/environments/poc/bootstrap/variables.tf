variable "aws_region" {
  description = "AWS region for backend resources."
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "S3 bucket name for Terraform state."
  type        = string
  default     = "opsfleet-tfstate-624654857501"
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking."
  type        = string
  default     = "terraform-state-locks"
}

variable "tags" {
  description = "Tags for backend resources."
  type        = map(string)
  default = {
    Project   = "opsfleet"
    ManagedBy = "terraform"
    Purpose   = "tf-backend"
  }
}
