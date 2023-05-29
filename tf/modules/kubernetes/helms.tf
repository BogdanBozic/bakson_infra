module "nginx-controller" {
  depends_on = [aws_eks_cluster.bakson, aws_eks_node_group.bakson]
  source = "terraform-iaac/nginx-controller/helm"

  additional_set = [
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
      value = "nlb"
      type  = "string"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
      value = "true"
      type  = "string"
    }
  ]
}

module "cert_manager" {
  depends_on = [aws_eks_cluster.bakson, aws_eks_node_group.bakson]
  source = "terraform-iaac/cert-manager/kubernetes"

  cluster_issuer_email = var.email
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argocd, aws_eks_cluster.bakson, aws_eks_node_group.bakson]
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.27.3"
  namespace  = "argocd"
  timeout    = "1200"
  values     = [file("${path.module}/k8s_resources/argocd-values.yaml")]
}