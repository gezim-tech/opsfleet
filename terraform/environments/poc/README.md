# EKS + Karpenter (Spot + Graviton) POC

This environment provisions:

- Dedicated VPC
- Amazon EKS cluster
- Karpenter controller
- Two Karpenter NodePools:
  - `spot-amd64` (x86 Spot)
  - `spot-arm64` (Graviton Spot)

## Notes on versions

- Kubernetes default is `1.35`.
- This matches the latest EKS Kubernetes version available as of **February 25, 2026**.
- If AWS releases a newer version, update `kubernetes_version` in `terraform.tfvars`.

## Prerequisites

- Terraform `>= 1.5.7`
- AWS credentials configured
- AWS CLI v2
- `kubectl`

## Remote state (S3 + DynamoDB lock)

Bootstrap backend infrastructure for this environment:

```bash
cd bootstrap
terraform init
terraform apply
cd ..
```

Then initialize this environment backend:

```bash
terraform init
```

Terraform state will be stored remotely in S3.

## Deploy

```bash
cp terraform.tfvars
terraform init
terraform plan
terraform apply
```

Configure kubeconfig:

```bash
aws eks update-kubeconfig --name <cluster_name> --region <aws_region>
```

## Validate Karpenter

```bash
kubectl get pods -n kube-system -l app.kubernetes.io/name=karpenter
kubectl get nodepools
kubectl get ec2nodeclasses
```

## x86 Spot workload

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-amd64
spec:
  replicas: 2
  selector:
    matchLabels:
      app: demo-amd64
  template:
    metadata:
      labels:
        app: demo-amd64
    spec:
      nodeSelector:
        karpenter.sh/nodepool: spot-amd64
        kubernetes.io/arch: amd64
      containers:
      - name: app
        image: public.ecr.aws/eks-distro/kubernetes/pause:3.10
        resources:
          requests:
            cpu: 250m
            memory: 128Mi
```

## Graviton Spot workload

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-arm64
spec:
  replicas: 2
  selector:
    matchLabels:
      app: demo-arm64
  template:
    metadata:
      labels:
        app: demo-arm64
    spec:
      nodeSelector:
        karpenter.sh/nodepool: spot-arm64
        kubernetes.io/arch: arm64
      containers:
      - name: app
        image: public.ecr.aws/eks-distro/kubernetes/pause:3.10
        resources:
          requests:
            cpu: 250m
            memory: 128Mi
```

## Cleanup

```bash
terraform destroy
```
