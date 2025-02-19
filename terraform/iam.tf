resource "aws_iam_role" "eks_fargate_role" {
  name = "eks-fargate-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })

  lifecycle {
    prevent_destroy       = true # ✅ Prevents accidental deletion
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks_fargate_policy" {
  role       = aws_iam_role.eks_fargate_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}



# EKS Admin Role
resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "eks_admin_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ])
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = each.value
}


resource "aws_iam_role_policy" "eks_policy" {
  name = "eks-inline-policy"
  role = aws_iam_role.eks_cluster_role.id
  policy = jsonencode({
    Statement = [{
      Action   = "eks:DescribeCluster"
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}


# EKS Fargate Execution Role
resource "aws_iam_role" "eks_fargate_execution_role" {
  name = var.eks_fargate_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_iam_role_policy_attachment" "eks_fargate_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ])
  role       = aws_iam_role.eks_fargate_execution_role.name
  policy_arn = each.value
}

# EKS User Role

resource "aws_iam_role" "eks_user_role" {
  name = var.eks_user_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = var.developer_user_arn
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_user_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  ])
  role       = aws_iam_role.eks_user_role.name
  policy_arn = each.value
}

