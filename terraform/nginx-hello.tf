variable "nginx-hello-name" {
  description = "Application name"
  default     = "nginx-hello"
}

resource "kubernetes_namespace" "apps" {
  metadata {
    name = "apps"
  }
}

resource "kubernetes_pod" "nginx-hello" {
  metadata {
    name   = var.nginx-hello-name
    labels = {
      app = var.nginx-hello-name
    }
  }

  spec {
    container {
      image = "${data.terraform_remote_state.aws.outputs.ecr_registry_url}:${var.commit_sha1}"
      name  = var.nginx-hello-name
    }
//    affinity {
//      node_affinity {
//        required_during_scheduling_ignored_during_execution {
//          node_selector_term {
//            match_expressions {
//              key      = "node.kubernetes.io/assignment"
//              operator = "In"
//              values   = ["applications"]
//            }
//          }
//        }
//      }
//    }
  }
}

resource "kubernetes_service" "nginx-hello" {
  metadata {
    name      = var.nginx-hello-name
    namespace = kubernetes_namespace.apps.metadata[0].name
    labels    = {
      app = var.nginx-hello-name
    }
  }
  spec {
    selector         = {
      app = var.nginx-hello-name
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }
  }
}


resource "kubernetes_deployment" "nginx-hello" {
  depends_on = [kubernetes_namespace.apps]

  metadata {
    name      = var.nginx-hello-name
    namespace = kubernetes_namespace.apps.metadata[0].name
    labels    = {
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
          image = "${data.terraform_remote_state.aws.outputs.ecr_registry_url}:${var.commit_sha1}"
          name  = var.nginx-hello-name


          resources {
            limits {
              cpu    = "0.5"
              memory = "128Mi"
            }
            requests {
              cpu    = "200m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "nginx-hello" {
  depends_on = [kubernetes_deployment.nginx-hello]

  spec {
    backend {
      service_name = kubernetes_deployment.nginx-hello.metadata[0].name
      service_port = "80"
    }
    rule {
      http {
        path {
          backend {
            service_name = kubernetes_deployment.nginx-hello.metadata[0].name
            service_port = "80"
          }
          path = "/nginx-hello"
        }
      }
    }
  }
  metadata {
    name      = kubernetes_deployment.nginx-hello.metadata[0].name
    namespace = kubernetes_namespace.apps.metadata[0].name
  }
}