variable "region" {
  description = "AWS region for the SecretStore"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix, e.g. retailpulse-dev"
  type        = string
}

variable "workload_namespace" {
  description = "Namespace for RetailPulse workloads"
  type        = string
  default     = "ns-retailpulse"
}