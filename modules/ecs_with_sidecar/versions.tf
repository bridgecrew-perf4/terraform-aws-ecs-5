terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      version = ">= 3.61"
    }
    template = {
      version = ">= 2.2.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.profile_to_use
}
