provider "kubernetes" {
  config_path = "~/.kube/config"
}

#Kubernetes namespace to hold application
resource "kubernetes_namespace" "terraform-k8s" {
  metadata {
    name = "terraform-k8s"
  }
}

#Kubernetes deployment 
resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.terraform-k8s.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:1.21.6"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

#Kubernetes service to access nginx webpage
resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.terraform-k8s.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.nginx.spec[0].template[0].metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "nginx_load_balancer_ip" {
  value = kubernetes_service.nginx.status[0].load_balancer[0].ingress[0].ip
}
