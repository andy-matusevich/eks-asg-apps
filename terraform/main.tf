provider "aws" {
  region = var.state_region
}

terraform {
  backend "s3" {}
}

variable "state_region" {}
variable "state_bucket" {}
variable "state_bucket_key" {}

data "terraform_remote_state" "aws" {
  backend = "s3"
  config {
    bucket = var.state_bucket
    key    = var.state_bucket_key
    region = var.state_region
  }
}
