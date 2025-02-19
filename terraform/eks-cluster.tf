# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  lifecycle {
    prevent_destroy       = false
    create_before_destroy = true   # Ensures Terraform recreates the role safely
    ignore_changes        = [name] # Prevents unnecessary changes
  }
}

# Attach EKS Cluster Policy to IAM Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS Cluster Definition
resource "aws_eks_cluster" "eks_cluster" {
  name     = "python-web-app-eksf"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets  # ✅ Only subnets should be defined
  }
}


