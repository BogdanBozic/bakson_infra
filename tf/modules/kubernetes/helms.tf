module "nginx-controller" {
  source = "terraform-iaac/nginx-controller/helm"
  depends_on = [
    aws_vpc.bakson,
    aws_internet_gateway.bakson,
    aws_route_table.bakson,
    aws_route_table_association.bakson,
    aws_subnet.bakson_control_plane[0],
    aws_subnet.bakson_control_plane[1],
    aws_security_group.bakson_master,
    aws_security_group.bakson_worker,
    aws_vpc_security_group_egress_rule.bakson_worker_outbound_vpc,
    aws_vpc_security_group_egress_rule.eks_cluster_outbound,
    aws_vpc_security_group_egress_rule.eks_cluster_vpc,
    aws_vpc_security_group_ingress_rule.eks_cluster_vpc,
    aws_vpc_security_group_egress_rule.eks_cluster_outbound,
    aws_eks_cluster.bakson,
    aws_eks_node_group.bakson,
    aws_vpc_security_group_ingress_rule.bakson_worker_vpc
  ]

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
  depends_on = [
    aws_vpc.bakson,
    aws_internet_gateway.bakson,
    aws_route_table.bakson,
    aws_route_table_association.bakson,
    aws_subnet.bakson_control_plane[0],
    aws_subnet.bakson_control_plane[1],
    aws_security_group.bakson_master,
    aws_security_group.bakson_worker,
    aws_vpc_security_group_egress_rule.bakson_worker_outbound_vpc,
    aws_vpc_security_group_egress_rule.eks_cluster_outbound,
    aws_vpc_security_group_egress_rule.eks_cluster_vpc,
    aws_vpc_security_group_ingress_rule.eks_cluster_vpc,
    aws_vpc_security_group_egress_rule.eks_cluster_outbound,
    aws_eks_cluster.bakson,
    aws_eks_node_group.bakson,
    aws_vpc_security_group_ingress_rule.bakson_worker_vpc
  ]
  source = "terraform-iaac/cert-manager/kubernetes"

  cluster_issuer_email = var.email
}

resource "kubernetes_namespace" "argocd" {
  depends_on = [
    aws_vpc.bakson,
    aws_internet_gateway.bakson,
    aws_route_table.bakson,
    aws_route_table_association.bakson,
    aws_subnet.bakson_control_plane[0],
    aws_subnet.bakson_control_plane[1],
    aws_security_group.bakson_master,
    aws_security_group.bakson_worker,
    aws_vpc_security_group_egress_rule.bakson_worker_outbound_vpc,
    aws_vpc_security_group_egress_rule.eks_cluster_outbound,
    aws_vpc_security_group_egress_rule.eks_cluster_vpc,
    aws_vpc_security_group_ingress_rule.eks_cluster_vpc,
    aws_vpc_security_group_egress_rule.eks_cluster_outbound,
    aws_eks_cluster.bakson,
    aws_eks_node_group.bakson,
    aws_vpc_security_group_ingress_rule.bakson_worker_vpc
  ]
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  depends_on = [
    aws_vpc.bakson,
    aws_internet_gateway.bakson,
    aws_route_table.bakson,
    aws_route_table_association.bakson,
    aws_subnet.bakson_control_plane[0],
    aws_subnet.bakson_control_plane[1],
    aws_security_group.bakson_master,
    aws_security_group.bakson_worker,
    aws_vpc_security_group_egress_rule.bakson_worker_outbound_vpc,
    aws_vpc_security_group_egress_rule.eks_cluster_outbound,
    aws_vpc_security_group_egress_rule.eks_cluster_vpc,
    aws_vpc_security_group_ingress_rule.eks_cluster_vpc,
    aws_vpc_security_group_egress_rule.eks_cluster_outbound,
    aws_eks_cluster.bakson,
    aws_eks_node_group.bakson,
    aws_vpc_security_group_ingress_rule.bakson_worker_vpc
  ]
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.27.3"
  namespace  = "argocd"
  timeout    = "1200"
  values     = [file("${path.module}/k8s_resources/argocd-values.yaml")]
}