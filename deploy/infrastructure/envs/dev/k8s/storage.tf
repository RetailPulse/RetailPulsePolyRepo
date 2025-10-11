resource "kubernetes_storage_class" "gp3" {
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner     = "ebs.csi.aws.com"
  volume_binding_mode     = "WaitForFirstConsumer"
  allow_volume_expansion  = true

  parameters = {
    type   = "gp3"
    fsType = "ext4"
  }

  # depends_on = [module.eks_stack] # Ensure EKS is ready
}