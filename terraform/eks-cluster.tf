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
    prevent_destroy = false
    create_before_destroy = true # Ensures Terraform recreates the role safely
    ignore_changes = [ name ]   # prevent un
  }

  depends_on = [aws_vpc.eks_vpc] # ✅ Ensures VPC exists before creating IAM role}
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "python-web-app-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = ["subnet-xxxxx", "subnet-yyyyy"] # Replace with your subnet IDs
  }
}
