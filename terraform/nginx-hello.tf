variable "nginx-hello-name" {
  description = "Application name"
  default     = "nginx-hello"
}

resource "kubernetes_deployment" "nginx-hello" {
  depends_on = [kubernetes_namespace.apps]

  metadata {
    name   = var.nginx-hello-name
    labels = {
      app = var.nginx-hello-name
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = var.nginx-hello-name
      }
    }

    template {
      metadata {
        labels = {
          app = var.nginx-hello-name
        }
      }

      spec {
        container {
          image = "${data.terraform_remote_state.aws.outputs.ecr_registry_url}:${var.commit_sha1}}"
          name  = var.nginx-hello-name

          resources {
            limits {
              cpu    = "0.5"
              memory = "128Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          #          liveness_probe {
          #            http_get {
          #              path = "/"
          #              port = 80
          #
          #              http_header {
          #                name  = "X-Custom-Header"
          #                value = "Awesome"
          #              }
          #            }

          #            initial_delay_seconds = 3
          #            period_seconds        = 3
          #          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "nginx-hello" {
  depends_on = [kubernetes_deployment.nginx-hello]

  spec {
    backend {
      service_name = kubernetes_deployment.nginx-hello.metadata.name
      service_port = "80"
    }
    rule {
      http {
        path {
          backend {
            service_name = kubernetes_deployment.nginx-hello.metadata.name
            service_port = "80"
          }
          path = "/"
        }
      }
    }
  }
  metadata {
    name      = kubernetes_deployment.nginx-hello.metadata.name
    namespace = kubernetes_namespace.apps.metadata.name
  }
}