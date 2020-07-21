locals {
  nginx_hello_name             = "nginx-hello"
  nginx_hello_replicas         = 2
  nginx_hello_service_port     = 80
  nginx_hello_target_port      = 80
  nginx_hello_session_affinity = "ClientIP"
  nginx_hello_path             = "/hello"
  nginx_hello_requests_cpu     = "100m"
  nginx_hello_requests_memory  = "30Mi"
  nginx_hello_limits_cpu       = "100m"
  nginx_hello_limits_memory    = "50Mi"
}


resource "kubernetes_deployment" "nginx-hello" {
  depends_on = [kubernetes_namespace.apps]

  metadata {
    name      = local.nginx_hello_name
    namespace = kubernetes_namespace.apps.metadata[0].name
    labels    = {
      app = local.nginx_hello_name
    }
  }
  spec {
    replicas = local.nginx_hello_replicas

    selector {
      match_labels = {
        app = local.nginx_hello_name
      }
    }
    template {
      metadata {
        labels = {
          app = local.nginx_hello_name
        }
      }
      spec {
        container {
          image = "${data.terraform_remote_state.aws.outputs.ecr_registry_url}:${var.commit_sha1}"
          name  = local.nginx_hello_name

          resources {
            requests {
              cpu    = local.nginx_hello_requests_cpu
              memory = local.nginx_hello_requests_memory
            }
            limits {
              cpu    = local.nginx_hello_limits_cpu
              memory = local.nginx_hello_limits_memory
            }
          }
        }
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "node.kubernetes.io/assignment"
                  operator = "In"
                  values   = [local.kubernetes_node_assignment]
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx-hello" {
  depends_on = [kubernetes_deployment.nginx-hello]

  metadata {
    name      = local.nginx_hello_name
    namespace = kubernetes_namespace.apps.metadata[0].name
    labels    = {
      app = local.nginx_hello_name
    }
  }
  spec {
    selector         = {
      app = local.nginx_hello_name
    }
    session_affinity = local.nginx_hello_session_affinity
    port {
      port        = local.nginx_hello_service_port
      target_port = local.nginx_hello_target_port
    }
  }
}

resource "kubernetes_ingress" "nginx-hello" {
  depends_on = [kubernetes_deployment.nginx-hello]

  spec {
    backend {
      service_name = kubernetes_deployment.nginx-hello.metadata[0].name
      service_port = local.nginx_hello_service_port
    }
    rule {
      host = "amatusevich.me"
      http {
        path {
          backend {
            service_name = kubernetes_deployment.nginx-hello.metadata[0].name
            service_port = local.nginx_hello_service_port
          }
          path = local.nginx_hello_path
        }
      }
    }
    tls {
      hosts = ["amatusevich.me"]
      secret_name = "amatusevich.me-hello"
    }
  }
  metadata {
    name      = kubernetes_deployment.nginx-hello.metadata[0].name
    namespace = kubernetes_namespace.apps.metadata[0].name
  }
}