resource "kubernetes_manifest" "app_ingress" {
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name      = "python-web-app-ingress"
      namespace = "default"
      annotations = {
        "kubernetes.io/ingress.class"      = "alb"
        "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      }
    }
    spec = {
      rules = [{
        host = "your-app.example.com"
        http = {
          paths = [{
            path     = "/"
            pathType = "Prefix"
            backend = {
              service = {
                name = "python-web-app-service"
                port = {
                  number = 80
                }
              }
            }
          }]
        }
      }]
    }
  }

  depends_on = [module.eks, kubernetes_manifest.alb_controller] # ✅ Ensure ALB Controller is created first
}
