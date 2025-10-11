variable "region" {
  description = "AWS region for the SecretStore"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix, e.g. retailpulse-dev"
  type        = string
}

variable "sample_namespace" {
  description = "Namespace used by the sample ExternalSecrets"
  type        = string
  default     = "sample"
}