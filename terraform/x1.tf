resource "kubernetes_deployment" "python_web_app" {
  metadata {
    name      = "python-web"
    namespace = "python-web"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "python-web"
      }
    }

    template {
      metadata {
        labels = {
          app = "python-web"
        }
      }

      spec {
        container {
          name  = "python-web"
          image = "mystic3raven/python-web-app:latest"

          env_from {
            config_map_ref {
              name = kubernetes_config_map.python_web_config.metadata[0].name
            }
          }

          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}
