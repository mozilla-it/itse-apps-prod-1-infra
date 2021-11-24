provider "aws" {
  region = "us-west-2"
}

module "ecr" {
  source            = "github.com/mozilla-it/terraform-modules//aws/ecr?ref=master"
  repo_name         = "refractr"
  create_user       = false
  create_gha_role   = true
  gha_sub_wildcards = ["repo:mozilla-it/refractr:*"]
}
