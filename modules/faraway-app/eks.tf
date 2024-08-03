module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id = data.aws_vpc.default.id
  # EKS does not support creating control plane instances in us-east-1e, so exclude it.
  subnet_ids = [for s in data.aws_subnets.default.ids : s if replace(s, "subnet-0972b738", "") == s]

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2_x86_64"
      instance_types = ["m6i.large"]
      min_size       = 1
      max_size       = 3
      desired_size   = 1
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = var.tags
}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --kubeconfig ${var.kubeconfig}"
  }
  depends_on = [ module.eks ]
  
}
