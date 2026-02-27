output "nodepools" {
  description = "Karpenter NodePools created by this module."
  value       = ["spot-amd64", "spot-arm64"]
}
