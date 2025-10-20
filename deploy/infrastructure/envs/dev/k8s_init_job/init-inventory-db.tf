locals {
  inventory_job_name = "init-inventory-db"
}

# --- ConfigMap holding SQL ---
resource "kubernetes_config_map" "init_inventory_sql" {
  metadata {
    name      = "${local.inventory_job_name}-sql"
    namespace = var.namespace
  }

  binary_data = {
    "inventory.init.sql" = filebase64("${path.module}/inventory.init.sql")
  }
}

# --- Kubernetes Job for initializing user database ---
resource "kubernetes_job" "init_inventory_db" {
  metadata {
    name      = local.inventory_job_name
    namespace = var.namespace
    annotations = {
      force_reinit_timestamp = var.force_reinit ? timestamp() : ""
    }
  }

  spec {
    backoff_limit              = 0
    ttl_seconds_after_finished = 600  # keep failed/success pods for 10 mins for debugging

    template {
      metadata {
        labels = {
          job = local.inventory_job_name
        }
      }

      spec {
        container {
          name  = "mysql-client"
          image = "mysql:8.0"
          command = [
            "sh", "-c",
            "mysql -h ${var.db_host} -u${var.db_user} < /sql/inventory.init.sql"
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
            name = kubernetes_config_map.init_inventory_sql.metadata[0].name
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

  depends_on = [kubernetes_config_map.init_inventory_sql]
}

# --- Local-exec to wait for job completion and delete it ---
resource "null_resource" "cleanup_inventory_db" {
  depends_on = [kubernetes_job.init_inventory_db]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "kubectl delete job init-inventory-db -n ${var.namespace} --ignore-not-found=true || true"
  }
}