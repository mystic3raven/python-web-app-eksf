
# Fetch existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-041a3b2e4a7f33dac" # Use the actual VPC ID from AWS CLI
}

# Fetch existing public subnets
data "aws_subnets" "existing_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
}

# Fetch the existing IAM role for EKS Cluster (Ensure this IAM role exists in AWS)
data "aws_iam_role" "eks_cluster_role" {
  name = "AWSServiceRoleForAmazonEKS" # Ensure this matches the actual IAM role in AWS
}

# Fetch the existing IAM role for EKS Node Group
data "aws_iam_role" "eks_node_role" {
  name = "AWSServiceRoleForAmazonEKSNodegroup" # Ensure this matches the actual IAM role in AWS
}
# EKS Cluster using existing subnets
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.existing_public_subnets.ids # Fetch existing subnets
  }
}
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-nodes-group"
  node_role_arn   = data.aws_iam_role.eks_node_role.arn          # Reference the existing IAM role
  subnet_ids      = data.aws_subnets.existing_public_subnets.ids # Fetch existing subnets
  scaling_config {
    desired_size = var.node_count
    min_size     = 1
    max_size     = 3
  }

  instance_types = [var.instance_type]
}

# Output Cluster Endpoint
