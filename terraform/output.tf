
output "eks_cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.repo.repository_url
}

output "load_balancer_dns" {
  description = "Load Balancer DNS"
  value       = try(kubernetes_service.python_web_service.status[0].load_balancer[0].ingress[0].hostname, "Not available")
}
