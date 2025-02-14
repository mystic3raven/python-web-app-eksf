

# Fetch the existing IAM role for EKS Cluster (Ensure this IAM role exists in AWS)
data "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"  # Ensure this matches the actual IAM role in AWS
}

# Fetch the existing IAM role for EKS Node Group
data "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"  # Ensure this matches the actual IAM role in AWS
}
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.eks_cluster_role.arn # reference to the IAM role
  

  vpc_config {
    subnet_ids = aws_subnet.public[*].id
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-nodes-group"
  node_role_arn   = data.aws_iam_role.eks_node_role.arn  # Reference the existing IAM role
  subnet_ids      = aws_subnet.public[*].id

  scaling_config {
    desired_size = var.node_count
    min_size     = 1
    max_size     = 3
  }

  instance_types = [var.instance_type]
}

# Output Cluster Endpoint
output "eks_cluster_endpoint" {
  description = "EKS Cluster API Endpoint"
  value       = aws_eks_cluster.eks_cluster.endpoint
}
