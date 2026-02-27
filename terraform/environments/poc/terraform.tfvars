aws_region         = "us-east-1"
cluster_name       = "opsfleet-eks-poc"
kubernetes_version = "1.35"
vpc_cidr           = "10.30.0.0/16"
az_count           = 3

tags = {
  Project     = "opsfleet"
  Environment = "poc"
  ManagedBy   = "terraform"
}
