variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint."
  type        = string
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "karpenter_chart_version" {
  description = "Karpenter Helm chart version."
  type        = string
}

variable "tags" {
  description = "Tags applied to Karpenter resources."
  type        = map(string)
}
