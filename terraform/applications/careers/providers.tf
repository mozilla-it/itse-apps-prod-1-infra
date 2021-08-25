provider "aws" {
  region = "us-west-2"

  # see https://github.com/hashicorp/terraform-provider-aws/issues/18311
  default_tags {
    tags = {
      Terraform = "true"
    }
  }
}

