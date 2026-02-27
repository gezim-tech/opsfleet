variable "cluster_name" {
  description = "EKS cluster name used for discovery tags."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "az_count" {
  description = "Number of AZs to use."
  type        = number
}

variable "tags" {
  description = "Tags applied to VPC resources."
  type        = map(string)
}
