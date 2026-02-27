locals {
  tags = merge(
    var.tags,
    {
      "karpenter.sh/discovery" = var.cluster_name
    }
  )
}

module "network" {
  source = "../../modules/network"

  cluster_name = var.cluster_name
  vpc_cidr     = var.vpc_cidr
  az_count     = var.az_count
  tags         = local.tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name            = var.cluster_name
  kubernetes_version      = var.kubernetes_version
  vpc_id                  = module.network.vpc_id
  private_subnets         = module.network.private_subnets
  intra_subnets           = module.network.intra_subnets
  bootstrap_instance_type = var.bootstrap_instance_type
  tags                    = local.tags

  depends_on = [module.network]
}

module "karpenter" {
  source = "../../modules/karpenter"

  providers = {
    aws          = aws
    aws.virginia = aws.virginia
    helm         = helm
    kubectl      = kubectl
  }

  cluster_name            = module.eks.cluster_name
  cluster_endpoint        = module.eks.cluster_endpoint
  aws_region              = var.aws_region
  karpenter_chart_version = var.karpenter_chart_version
  tags                    = local.tags

  depends_on = [module.eks]
}
