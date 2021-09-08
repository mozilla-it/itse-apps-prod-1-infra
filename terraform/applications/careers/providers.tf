provider "aws" {
  region = local.region

  # see https://github.com/hashicorp/terraform-provider-aws/issues/18311
  default_tags {
    tags = {
      Terraform = "true"
    }
  }
}


# some objects, like lambdas at edge, must be deployed in east
provider "aws" {
  alias  = "aws-east"
  region = "us-east-1"

  default_tags {
    tags = {
      Environment   = local.environment
      Project       = local.project
      Project-Desc  = local.project_desc
      Project-Email = local.project_email
      Region        = local.region
      Terraform     = "true"
    }
  }
}
