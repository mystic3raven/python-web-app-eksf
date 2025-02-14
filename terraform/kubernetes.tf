resource "null_resource" "apply_kubernetes_manifests" {
  depends_on = [aws_eks_cluster.cluster]

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.aws_region}
      kubectl apply -f ../kubernetes/deployment.yaml
      kubectl apply -f ../kubernetes/service.yaml
      kubectl apply -f ../kubernetes/ingress.yaml
    EOT
  }
}
