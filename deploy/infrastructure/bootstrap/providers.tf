variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "project" {
  type    = string
  default = "retailpulse"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project = var.project
      Env     = "bootstrap"
      IaC     = "opentofu"
    }
  }
}