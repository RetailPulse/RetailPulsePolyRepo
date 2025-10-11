resource "kubernetes_namespace" "sample" {
  metadata {
    name = var.sample_namespace
  }
}