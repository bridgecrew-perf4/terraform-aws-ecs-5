terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      version = "~> 3.63"
    }
    template = {
      version = "~> 2.2.0"
    }
  }
}
