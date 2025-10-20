resource "kubernetes_namespace" "sample" {
  metadata {
    name = var.workload_namespace
  }
    # ensure K8s default SA exists before manifests are applied
  wait_for_default_service_account = true
}

resource "kubernetes_namespace" "observeNS" {
  metadata {
    name = var.observe_namespace
  }
    # ensure K8s default SA exists before manifests are applied
  wait_for_default_service_account = true
}