provider "aws" {
  region = local.region

  # see https://github.com/hashicorp/terraform-provider-aws/issues/18311
  default_tags {
    tags = {
      Terraform = "true"
    }
  }
}

