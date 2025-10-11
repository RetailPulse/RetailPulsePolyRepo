resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "kubernetes_persistent_volume_claim" "traefik_acme" {
  metadata {
    name      = "traefik-acme-pvc"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = "gp3"
  }

  depends_on = [kubernetes_namespace.traefik]
}

resource "helm_release" "traefik_crds" {
  name       = "traefik-crds"
  namespace  = kubernetes_namespace.traefik.metadata[0].name
  repository = "https://traefik.github.io/charts"
  chart      = "traefik-crds"
  version    = "1.0.0"
  create_namespace = false

  depends_on = [kubernetes_namespace.traefik]
}

resource "helm_release" "traefik" {
  name       = "traefik"
  namespace  = kubernetes_namespace.traefik.metadata[0].name
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = "37.1.2"

  values = [
    file("${path.module}/traefik-values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.traefik,
    helm_release.traefik_crds
  ]
}

resource "kubernetes_manifest" "traefik_dashboard_ingressroute" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "traefik-dashboard"
      namespace = "traefik"
    }
    spec = {
      entryPoints = ["web"]
      routes = [
        {
          match = "PathPrefix(`/dashboard`) || PathPrefix(`/api`)"
          kind  = "Rule"
          services = [
            {
              name = "api@internal"
              kind = "TraefikService"
            }
          ]
        }
      ]
    }    
  }
  
  depends_on = [
    helm_release.traefik
  ]
}
