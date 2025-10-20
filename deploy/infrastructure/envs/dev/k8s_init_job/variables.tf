variable "namespace" { type = string }

# Auth (user) database connection info
variable "db_auth_host" { type = string }
variable "db_auth_admin" { type = string }
variable "db_auth_password" { type = string }
variable "db_auth_name" { type = string }

# Core database connection info
variable "db_host" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

# When true, re-run the job even if it's already completed before
variable "force_reinit" {
  description = "Set to true to force reinitialization (recreate the job)"
  type        = bool
  default     = false
}