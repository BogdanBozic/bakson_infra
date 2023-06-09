resource "aws_eks_node_group" "bakson" {
  cluster_name    = aws_eks_cluster.bakson.name
  node_group_name = "bakson"
  node_role_arn   = aws_iam_role.bakson_worker.arn
  subnet_ids      = aws_subnet.bakson_control_plane[*].id
  instance_types  = ["t2.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.bakson_worker-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.bakson_worker-AmazonEKS_CNI_Policy,
  ]
}