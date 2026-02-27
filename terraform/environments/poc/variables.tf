variable "aws_region" {
  description = "AWS region where infrastructure will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name for the EKS cluster."
  type        = string
  default     = "opsfleet-eks"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.35"
}

variable "vpc_cidr" {
  description = "CIDR block for the dedicated VPC."
  type        = string
  default     = "10.30.0.0/16"
}

variable "az_count" {
  description = "Number of AZs to use for the VPC."
  type        = number
  default     = 3

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 6
    error_message = "az_count must be between 2 and 6."
  }
}

variable "bootstrap_instance_type" {
  description = "Instance type for the bootstrap managed node group that runs core addons (including Karpenter)."
  type        = string
  default     = "t3.small"
}

variable "karpenter_chart_version" {
  description = "Karpenter Helm chart version."
  type        = string
  default     = "1.8.0"
}

variable "tags" {
  description = "Common tags applied to created resources."
  type        = map(string)
  default = {
    Project     = "opsfleet"
    Environment = "poc"
    ManagedBy   = "terraform"
  }
}
