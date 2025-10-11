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

# core-mysql -> K8s Secret 'core-db' in sample ns
resource "kubernetes_manifest" "core_db_extsec" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata   = { name = "core-db", namespace = "sample" }
    spec = {
      refreshInterval = "1h"
      secretStoreRef  = { name = "aws-secrets", kind = "ClusterSecretStore" } # <- change
      target = {
        name           = "core-db"
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
        { secretKey = "host",     remoteRef = { key = "${var.name_prefix}/db/core/admin", property = "host" } },
        { secretKey = "port",     remoteRef = { key = "${var.name_prefix}/db/core/admin", property = "port" } },
        { secretKey = "dbname",   remoteRef = { key = "${var.name_prefix}/db/core/admin", property = "dbname" } },
        { secretKey = "username", remoteRef = { key = "${var.name_prefix}/db/core/admin", property = "username" } },
        { secretKey = "password", remoteRef = { key = "${var.name_prefix}/db/core/admin", property = "password" } },
      ]
    }
  }
  depends_on = [
      kubernetes_namespace.sample,
      kubernetes_manifest.secret_store
  ]
}

# auth-mysql -> K8s Secret 'auth-db'
resource "kubernetes_manifest" "auth_db_extsec" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata   = { name = "auth-db", namespace = "sample" }
    spec = {
      refreshInterval = "1h"
      secretStoreRef  = { name = "aws-secrets", kind = "ClusterSecretStore" }
      target = {
        name           = "auth-db"
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
        { secretKey = "host",     remoteRef = { key = "${var.name_prefix}/db/auth/admin", property = "host" } },
        { secretKey = "port",     remoteRef = { key = "${var.name_prefix}/db/auth/admin", property = "port" } },
        { secretKey = "dbname",   remoteRef = { key = "${var.name_prefix}/db/auth/admin", property = "dbname" } },
        { secretKey = "username", remoteRef = { key = "${var.name_prefix}/db/auth/admin", property = "username" } },
        { secretKey = "password", remoteRef = { key = "${var.name_prefix}/db/auth/admin", property = "password" } },
      ]
    }
  }
  depends_on = [
      kubernetes_namespace.sample,
      kubernetes_manifest.secret_store
  ]
}

# docdb -> K8s Secret 'docdb'
resource "kubernetes_manifest" "docdb_extsec" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata   = { name = "docdb", namespace = "sample" }
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