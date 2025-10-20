# ClusterSecretStore (cluster-scoped)
resource "kubernetes_manifest" "secret_store" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata   = {
      name = "aws-secrets"
      # no namespace for ClusterSecretStore
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = var.region
          # ESO uses IRSA; no static creds here
        }
      }
    }
  }
}

# docdb -> K8s Secret 'docdb'
resource "kubernetes_manifest" "docdb_extsec" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata   = { name = "docdb", namespace = var.workload_namespace }
    spec = {
      refreshInterval = "1h"
      secretStoreRef  = { name = "aws-secrets", kind = "ClusterSecretStore" }
      
      target = {
        name           = "docdb"
        creationPolicy = "Owner"
        template = {
          data = {
            MONGO_HOST = "{{ .host }}"
            MONGO_PORT = "{{ .port | toString }}"
            MONGO_DB   = "{{ .dbname }}"
            MONGO_USER = "{{ .username }}"
            MONGO_PASS = "{{ .password }}"
          }
        }
      }
      data = [
        { secretKey = "host",     remoteRef = { key = "${var.name_prefix}/db/docdb/admin", property = "host" } },
        { secretKey = "port",     remoteRef = { key = "${var.name_prefix}/db/docdb/admin", property = "port" } },
        { secretKey = "dbname",   remoteRef = { key = "${var.name_prefix}/db/docdb/admin", property = "dbname" } },
        { secretKey = "username", remoteRef = { key = "${var.name_prefix}/db/docdb/admin", property = "username" } },
        { secretKey = "password", remoteRef = { key = "${var.name_prefix}/db/docdb/admin", property = "password" } },
      ]
    }
  }
  depends_on = [
      kubernetes_namespace.sample,
      kubernetes_manifest.secret_store
  ]
}

# auth-mysql -> K8s Secret 'auth-db-secret'
resource "kubernetes_manifest" "auth_db_extsec" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata   = { name = "auth-db-secret", namespace = var.workload_namespace }
    spec = {
      refreshInterval = "1h"
      secretStoreRef  = { name = "aws-secrets", kind = "ClusterSecretStore" }

      target = {
        name           = "auth-db-secret"
        creationPolicy = "Owner"
        template = {
          data = {
            DB_HOST     = "{{ .host }}"
            DB_PORT     = "{{ .port | toString }}"
            DB_NAME     = "{{ .dbname }}"
            DB_USER     = "{{ .username }}"
            DB_PASSWORD = "{{ .password }}"
          }
        }
      }
      data = [
        { secretKey = "host",     remoteRef = { key = "${var.name_prefix}/db/auth-secret", property = "host" } },
        { secretKey = "port",     remoteRef = { key = "${var.name_prefix}/db/auth-secret", property = "port" } },
        { secretKey = "dbname",   remoteRef = { key = "${var.name_prefix}/db/auth-secret", property = "dbname" } },
        { secretKey = "username", remoteRef = { key = "${var.name_prefix}/db/auth-secret", property = "username" } },
        { secretKey = "password", remoteRef = { key = "${var.name_prefix}/db/auth-secret", property = "password" } },
      ]
    }
  }
  depends_on = [
      kubernetes_namespace.sample,
      kubernetes_manifest.secret_store
  ]
}

# be-mysql -> K8s Secret 'be-db' in sample ns
resource "kubernetes_manifest" "be_db_extsec" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata   = { name = "be-db-secret", namespace = var.workload_namespace }
    spec = {
      refreshInterval = "1h"
      secretStoreRef  = { name = "aws-secrets", kind = "ClusterSecretStore" } 

      target = {
        name           = "be-db-secret"
        creationPolicy = "Owner"
        template = {
          data = {
            DB_HOST     = "{{ .host }}"
            DB_PORT     = "{{ .port | toString }}"
            DB_NAME     = "{{ .dbname }}"
            DB_USER     = "{{ .username }}"
            DB_PASSWORD = "{{ .password }}"
          }
        }
      }
      data = [
        { secretKey = "host",     remoteRef = { key = "${var.name_prefix}/db/be-secret", property = "host" } },
        { secretKey = "port",     remoteRef = { key = "${var.name_prefix}/db/be-secret", property = "port" } },
        { secretKey = "dbname",   remoteRef = { key = "${var.name_prefix}/db/be-secret", property = "dbname" } },
        { secretKey = "username", remoteRef = { key = "${var.name_prefix}/db/be-secret", property = "username" } },
        { secretKey = "password", remoteRef = { key = "${var.name_prefix}/db/be-secret", property = "password" } },
      ]
    }
  }
  depends_on = [
      kubernetes_namespace.sample,
      kubernetes_manifest.secret_store
  ]
}

# inventory-mysql -> K8s Secret 'inventory-db' in sample ns
resource "kubernetes_manifest" "inventory_db_extsec" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata   = { name = "inventory-db-secret", namespace = var.workload_namespace }
    spec = {
      refreshInterval = "1h"
      secretStoreRef  = { name = "aws-secrets", kind = "ClusterSecretStore" } 

      target = {
        name           = "inventory-db-secret"
        creationPolicy = "Owner"
        template = {
          data = {
            DB_HOST     = "{{ .host }}"
            DB_PORT     = "{{ .port | toString }}"
            DB_NAME     = "{{ .dbname }}"
            DB_USER     = "{{ .username }}"
            DB_PASSWORD = "{{ .password }}"
          }
        }
      }
      data = [
        { secretKey = "host",     remoteRef = { key = "${var.name_prefix}/db/inventory-secret", property = "host" } },
        { secretKey = "port",     remoteRef = { key = "${var.name_prefix}/db/inventory-secret", property = "port" } },
        { secretKey = "dbname",   remoteRef = { key = "${var.name_prefix}/db/inventory-secret", property = "dbname" } },
        { secretKey = "username", remoteRef = { key = "${var.name_prefix}/db/inventory-secret", property = "username" } },
        { secretKey = "password", remoteRef = { key = "${var.name_prefix}/db/inventory-secret", property = "password" } },
      ]
    }
  }
  depends_on = [
      kubernetes_namespace.sample,
      kubernetes_manifest.secret_store
  ]
}

# sales-mysql -> K8s Secret 'sales-db' in sample ns
resource "kubernetes_manifest" "sales_db_extsec" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata   = { name = "sales-db-secret", namespace = var.workload_namespace }
    spec = {
      refreshInterval = "1h"
      secretStoreRef  = { name = "aws-secrets", kind = "ClusterSecretStore" } 

      target = {
        name           = "sales-db-secret"
        creationPolicy = "Owner"
        template = {
          data = {
            DB_HOST     = "{{ .host }}"
            DB_PORT     = "{{ .port | toString }}"
            DB_NAME     = "{{ .dbname }}"
            DB_USER     = "{{ .username }}"
            DB_PASSWORD = "{{ .password }}"
          }
        }
      }
      data = [
        { secretKey = "host",     remoteRef = { key = "${var.name_prefix}/db/sales-secret", property = "host" } },
        { secretKey = "port",     remoteRef = { key = "${var.name_prefix}/db/sales-secret", property = "port" } },
        { secretKey = "dbname",   remoteRef = { key = "${var.name_prefix}/db/sales-secret", property = "dbname" } },
        { secretKey = "username", remoteRef = { key = "${var.name_prefix}/db/sales-secret", property = "username" } },
        { secretKey = "password", remoteRef = { key = "${var.name_prefix}/db/sales-secret", property = "password" } },
      ]
    }
  }
  depends_on = [
      kubernetes_namespace.sample,
      kubernetes_manifest.secret_store
  ]
}

# payment-mysql -> K8s Secret 'payment-db' in sample ns
resource "kubernetes_manifest" "payment_db_extsec" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata   = { name = "payment-db-secret", namespace = var.workload_namespace }
    spec = {
      refreshInterval = "1h"
      secretStoreRef  = { name = "aws-secrets", kind = "ClusterSecretStore" } 

      target = {
        name           = "payment-db-secret" 
        creationPolicy = "Owner"
        template = {
          data = {
            DB_HOST     = "{{ .host }}"
            DB_PORT     = "{{ .port | toString }}"
            DB_NAME     = "{{ .dbname }}"
            DB_USER     = "{{ .username }}"
            DB_PASSWORD = "{{ .password }}"
          }
        }
      }
      data = [
        { secretKey = "host",     remoteRef = { key = "${var.name_prefix}/db/payment-secret" , property = "host" } },
        { secretKey = "port",     remoteRef = { key = "${var.name_prefix}/db/payment-secret" , property = "port" } },
        { secretKey = "dbname",   remoteRef = { key = "${var.name_prefix}/db/payment-secret" , property = "dbname" } },
        { secretKey = "username", remoteRef = { key = "${var.name_prefix}/db/payment-secret" , property = "username" } },
        { secretKey = "password", remoteRef = { key = "${var.name_prefix}/db/payment-secret" , property = "password" } },
      ]
    }
  }
  depends_on = [
      kubernetes_namespace.sample,
      kubernetes_manifest.secret_store
  ]
}