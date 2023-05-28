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
