
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

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.role_arn  # ✅ Now using the variable instead of a direct reference

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [aws_iam_role.eks_cluster]
}
