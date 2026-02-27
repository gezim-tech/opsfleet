variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for EKS."
  type        = string
}

variable "private_subnets" {
  description = "Private subnets for worker nodes."
  type        = list(string)
}

variable "intra_subnets" {
  description = "Intra subnets for control plane ENIs."
  type        = list(string)
}

variable "bootstrap_instance_type" {
  description = "Instance type for bootstrap managed node group."
  type        = string
}

variable "tags" {
  description = "Tags applied to EKS resources."
  type        = map(string)
}
