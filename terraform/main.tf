locals {
  cluster_features = {
    "flux"               = true
    "flux_helm_operator" = true
    "external_secrets"   = true
    "aws_calico"         = true
  }

  flux_settings = {
    "git.url"    = "git@github.com:mozilla-it/itse-apps-prod-1-infra"
    "git.branch" = "main"
  }

  node_groups = {
    default_node_group = {
      # For a map of objects, none or all variable values must be defined.
      # https://github.com/hashicorp/terraform/issues/19898
      desired_capacity = 3,
      min_capacity     = 3,
      disk_size        = 120,
      max_capacity     = 20,
      instance_type    = "m5.large",
      subnets          = data.terraform_remote_state.vpc.outputs.private_subnets
    }
  }
}

module "itse-apps-prod-1" {
  source                        = "github.com/mozilla-it/terraform-modules//aws/eks?ref=master"
  cluster_name                  = "itse-apps-prod-1"
  cluster_version               = "1.17"
  vpc_id                        = data.terraform_remote_state.vpc.outputs.vpc_id
  cluster_subnets               = data.terraform_remote_state.vpc.outputs.public_subnets
  cluster_features              = local.cluster_features
  flux_settings                 = local.flux_settings
  external_secrets_secret_paths = ["/prod/*"]
  node_groups                   = local.node_groups
  admin_users_arn               = ["arn:aws:iam::783633885093:role/maws-admin", "arn:aws:iam::517826968395:role/itsre-admin"]
}
