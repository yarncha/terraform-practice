provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.14.8"
}