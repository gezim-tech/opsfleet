# Terraform Structure

This directory follows a module + environment layout:

- `modules/network`: VPC and subnet provisioning
- `modules/eks`: EKS cluster and bootstrap managed node group
- `modules/karpenter`: Karpenter IAM, controller Helm release, and NodePool manifests
- `environments/poc`: deployable root for this assignment

Use this environment as the entrypoint:

```bash
cd environments/poc
cd bootstrap
terraform init
terraform apply

cd ..
terraform init
terraform plan
terraform apply
```

Detailed usage and workload examples are in:

- `environments/poc/README.md`
