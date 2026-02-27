output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs."
  value       = module.vpc.private_subnets
}

output "intra_subnets" {
  description = "Intra subnet IDs used by EKS control plane."
  value       = module.vpc.intra_subnets
}
