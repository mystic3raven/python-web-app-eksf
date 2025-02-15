# 🚀 IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# 🚀 IAM Role for GitHub Actions OIDC
resource "aws_iam_role" "GitHubActionsOIDC" {
  name = "GitHubActionsOIDC"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:sub" = "repo:your-org/your-repo:ref:refs/heads/main"
        }
      }
    }]
  })
}

# 🚀 IAM Policy for GitHub Actions Access to EKS
resource "aws_iam_policy" "GitHubActionsEKSPolicy" {
  name        = "GitHubActionsEKSPolicy"
  description = "Allows GitHub Actions to interact with EKS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::my-eks-artifacts/*"
      }
    ]
  })
}

# 🚀 Attach IAM Policy to GitHubActionsOIDC Role
resource "aws_iam_role_policy_attachment" "GitHubActionsEKSAttach" {
  policy_arn = aws_iam_policy.GitHubActionsEKSPolicy.arn
  role       = aws_iam_role.GitHubActionsOIDC.name
}
