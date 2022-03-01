terraform {
  backend "s3" {
    bucket = "itse-apps-prod-1-state"
    key    = "us-west-2/etherpad/prod/terraform.tfstate"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0.4"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "itsre-state-783633885093"
    key    = "terraform/deploy.tfstate"
    region = "eu-west-1"
  }
}