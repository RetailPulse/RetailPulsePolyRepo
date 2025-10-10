variable "vpc_id" {
  description = "VPC where EKS will run"
  type        = string
}

variable "private_subnets" {
  description = "Private app subnets for EKS nodes"
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix like retailpulse-dev"
  type        = string
}

variable "project" { type = string }
variable "env"     { type = string }

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}