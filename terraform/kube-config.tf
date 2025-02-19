
# Fetch EKS authentication details
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
}

# Add `depends_on` to Kubernetes resources instead
resource "kubernetes_namespace" "python_web_app" {
  metadata {
    name = "python-web-app"
  }

  depends_on = [aws_eks_cluster.eks_cluster] # ✅ This is allowed in a resource block
}
