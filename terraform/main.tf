resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [aws_iam_role.eks_cluster]
}

resource "aws_eks_fargate_profile" "this" {
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "default"
  pod_execution_role_arn = aws_iam_role.eks_fargate.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = "default"
  }

  depends_on = [aws_eks_cluster.this, aws_iam_role.eks_fargate]  # ✅ Ensure cluster is ready first
}
