data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.bakson.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "bakson" {
  name = var.project_name
}

data "aws_lb" "nlb_ingress_nginx" {
  depends_on = [module.nginx-controller]
  tags = {
    "kubernetes.io/cluster/bakson_project" = "owned"
    "kubernetes.io/service-name" = "kube-system/ingress-nginx-controller"
  }
}