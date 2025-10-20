locals {
  payment_job_name = "init-payment-db"
}

# --- ConfigMap holding SQL ---
resource "kubernetes_config_map" "init_sql_payment" {
  metadata {
    name      = "${local.payment_job_name}-sql"
    namespace = var.namespace
  }

  data = {
    "init.sql" = file("${path.module}/payment.init.sql")
  }
}

# --- Kubernetes Job definition ---
resource "kubernetes_job" "mysql_init_payment" {
  metadata {
    name      = local.payment_job_name
    namespace = var.namespace
    annotations = {
      force_reinit_timestamp = var.force_reinit ? timestamp() : ""
    }
  }

  spec {
    backoff_limit = 2

    template {
      metadata {
        labels = {
          job = local.payment_job_name
        }
      }

      spec {
        container {
          name  = "mysql-client"
          image = "mysql:8.0"
          command = [
            "sh", "-c",
            "mysql -h ${var.db_host} -u${var.db_user} < /sql/init.sql"
          ]
          env {
            name  = "MYSQL_PWD"
            value = var.db_password
          }
          volume_mount {
            name       = "sql"
            mount_path = "/sql"
          }
        }

        volume {
          name = "sql"
          config_map {
            name = kubernetes_config_map.init_sql_payment.metadata[0].name
          }
        }

        restart_policy = "OnFailure"
      }
    }
  }

  # Run only when forced, or first time (create new job on force)
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      metadata[0].annotations,
    ]
  }

  depends_on = [kubernetes_config_map.init_sql_payment]
}

# --- Local-exec to wait for job completion and delete it ---
resource "null_resource" "cleanup_be_payment" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "kubectl delete job init-payment-db -n ${var.namespace} --ignore-not-found=true || true"
  }

  depends_on = [kubernetes_job.mysql_init_payment]
}