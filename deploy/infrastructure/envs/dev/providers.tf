variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "project" {
  type    = string
  default = "retailpulse"
}

variable "env" {
  type    = string
  default = "dev"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project = var.project
      Env     = var.env
      IaC     = "opentofu"
    }
  }
}