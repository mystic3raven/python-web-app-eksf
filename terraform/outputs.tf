
output "cluster_id" {
  description = "EKS Cluster ID"
  value       = module.eks.cluster_id # ✅ Reference module.eks, not aws_eks_cluster.this
}

output "cluster_endpoint" {
  description = "EKS Cluster API Endpoint"
  value       = module.eks.cluster_endpoint # ✅ Reference module.eks
}

output "cluster_certificate_authority_data" {
  description = "EKS Cluster Certificate Authority Data"
  value       = module.eks.cluster_certificate_authority_data # ✅ Reference module.eks
}

