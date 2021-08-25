provider "aws" {
  region = "us-west-2"

  # see https://github.com/hashicorp/terraform-provider-aws/issues/18311
  default_tags {
    tags = {
      Terraform = "true"
    }
  }
}

# Needed for Cloudfront SSL cert
//provider "aws" {
//  alias  = "us-east-1"
//  region = "us-east-1"
//
//  # see https://github.com/hashicorp/terraform-provider-aws/issues/18311
//  default_tags {
//    tags = {
//      CostCenter    = var.cost_center
//      Environment   = var.environment
//      Project       = var.project
//      Project-Desc  = var.project_desc
//      Project-Email = var.project_email
//      Region        = var.region
//      Terraform     = "true"
//    }
//  }
//}
