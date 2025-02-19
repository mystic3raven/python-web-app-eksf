output "eks_cluster_name" {
  value = module.eks.cluster_id
}

output "eks_fargate_namespace" {
  value = "python-web-app-eksf"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.python_web_app.repository_url
}
output "cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}
