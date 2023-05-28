terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.25.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.0"
    }
  }
}

provider "aws" {
  region     = var.default_region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "github" {
  token = var.github_token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.bakson.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.bakson.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.bakson.name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.bakson.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.bakson.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.bakson.name]
    command     = "aws"
  }
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.bakson.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.bakson.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.bakson.name]
    command     = "aws"
  }
}
