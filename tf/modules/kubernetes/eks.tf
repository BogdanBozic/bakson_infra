resource "aws_eks_cluster" "bakson" {
  name     = var.project_name
  role_arn = aws_iam_role.bakson_master.arn

  vpc_config {
    security_group_ids = [aws_security_group.bakson_master.id]
    subnet_ids         = aws_subnet.bakson_control_plane.*.id
  }

  depends_on = [
    aws_iam_role_policy_attachment.bakson-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.bakson-AmazonEKSServicePolicy,
  ]
}
