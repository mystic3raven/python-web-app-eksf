resource "kubernetes_manifest" "alb_controller" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "aws-load-balancer-controller"
      namespace = "kube-system"
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = "aws-load-balancer-controller"
        }
      }
      template = {
        metadata = {
          labels = {
            app = "aws-load-balancer-controller"
          }
        }
        spec = {
          serviceAccountName = "aws-load-balancer-controller"
          containers = [{
            name  = "aws-load-balancer-controller"
            image = "602401143452.dkr.ecr.us-west-2.amazonaws.com/amazon/aws-load-balancer-controller:v2.4.1"
            args  = [
              "--cluster-name=${module.eks.cluster_id}",
              "--ingress-class=alb",
              "--aws-region=us-west-2"
            ]
          }]
        }
      }
    }
  }

  depends_on = [module.eks]  # ✅ Ensure EKS is created first
}

