provider "aws" {
  region = var.state_region
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "aws" {
  backend = "s3"
  config  = {
    bucket = var.state_bucket
    key    = var.state_bucket_key
    region = var.state_region
  }
}

variable "state_region" {}
variable "state_bucket" {}
variable "state_bucket_key" {}
variable "commit_sha1" {}

locals {
  # common vars
  kubernetes_node_assignment = "applications"
  kubernetes_namespace       = "apps"
}

resource "kubernetes_namespace" "apps" {
  metadata {
    name = local.kubernetes_namespace
  }
}


