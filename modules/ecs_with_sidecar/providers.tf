terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      version = "~> 3.74"
    }
    template = {
      version = "~> 2.2.0"
    }
  }
}
