variable "namespace" { type = string }

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
