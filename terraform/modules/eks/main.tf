module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  endpoint_public_access                   = true
  endpoint_private_access                  = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.intra_subnets

  addons = {
    coredns                  = {}
    "kube-proxy"             = {}
    "vpc-cni"                = {}
    "eks-pod-identity-agent" = {}
  }

  node_security_group_tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }

  tags = var.tags
}

data "aws_iam_policy_document" "bootstrap_node_assume_role" {
  statement {
    sid     = "EKSNodeAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bootstrap_node" {
  name_prefix          = "bootstrap-eks-node-group-"
  assume_role_policy   = data.aws_iam_policy_document.bootstrap_node_assume_role.json
  force_detach_policies = true

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "bootstrap_node_worker" {
  role       = aws_iam_role.bootstrap_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "bootstrap_node_cni" {
  role       = aws_iam_role.bootstrap_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "bootstrap_node_ecr" {
  role       = aws_iam_role.bootstrap_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "bootstrap" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "bootstrap"
  node_role_arn   = aws_iam_role.bootstrap_node.arn
  subnet_ids      = var.private_subnets

  ami_type       = "AL2023_x86_64_STANDARD"
  instance_types = [var.bootstrap_instance_type]
  capacity_type = "SPOT"
  labels = {
    "node-role" = "bootstrap"
  }

  scaling_config {
    min_size     = 1
    max_size     = 2
    desired_size = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.bootstrap_node_worker,
    aws_iam_role_policy_attachment.bootstrap_node_cni,
    aws_iam_role_policy_attachment.bootstrap_node_ecr
  ]

  tags = merge(
    var.tags,
    {
      Name = "bootstrap"
    }
  )
}
