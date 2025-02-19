# Define IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster" {
  name = "python-web-app-eksf-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach EKS Cluster IAM Policy
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Define the EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "python-web-app-eksf"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [aws_iam_role.eks_cluster]
}

# Define IAM Role for Fargate Execution
resource "aws_iam_role" "eks_fargate" {
  name = "python-web-app-eksf-fargate-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks-fargate-pods.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach IAM Policy to Fargate Execution Role
resource "aws_iam_role_policy_attachment" "eks_fargate_execution" {
  role       = aws_iam_role.eks_fargate.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

# Define the Fargate Profile
resource "aws_eks_fargate_profile" "this" {
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "default"
  pod_execution_role_arn = aws_iam_role.eks_fargate.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = "default"
  }

  depends_on = [aws_eks_cluster.this, aws_iam_role.eks_fargate]
}
