locals {
  cluster_features = {
    "prometheus"         = true
    "flux"               = true
    "flux_helm_operator" = true
    "external_secrets"   = true
    "aws_calico"         = true
    "fluentd_papertrail" = true
  }

  flux_settings = {
    "git.url"    = "git@github.com:mozilla-it/itse-apps-prod-1-infra"
    "git.branch" = "main"
  }

  node_groups = {
    default_node_group = {
      desired_capacity = 5,
      min_capacity     = 5,
      disk_size        = 120,
      max_capacity     = 20,
      instance_types   = ["m5.large"],
      subnets          = data.terraform_remote_state.vpc.outputs.private_subnets
    }
  }

  external_secrets_settings = {
    secrets_path = "/prod/*"
  }

  fluentd_papertrail_settings = {
    "externalSecrets.secretsKey" = "/prod/${module.itse-apps-prod-1.cluster_id}-papertrail"
  }

  subnet_az = [for s in data.aws_subnet.public : s.availability_zone]
  subnet_id = [for s in data.aws_subnet.public : s.id]
}

module "itse-apps-prod-1" {
  source                      = "github.com/mozilla-it/terraform-modules//aws/eks?ref=master"
  cluster_name                = "itse-apps-prod-1"
  cluster_version             = "1.18"
  vpc_id                      = data.terraform_remote_state.vpc.outputs.vpc_id
  cluster_subnets             = data.terraform_remote_state.vpc.outputs.public_subnets
  cluster_features            = local.cluster_features
  flux_settings               = local.flux_settings
  external_secrets_settings   = local.external_secrets_settings
  node_groups                 = local.node_groups
  fluentd_papertrail_settings = local.fluentd_papertrail_settings
  admin_users_arn             = ["arn:aws:iam::783633885093:role/maws-admin", "arn:aws:iam::517826968395:role/itsre-admin"]
}

# Chicken and egg issue, this needs to exist first
# before we can create the refractr ingress-nginx
resource "aws_eip" "refractr_eip" {
  count = length(local.subnet_az)
  vpc   = true

  tags = {
    Name        = "refractr-prod-${local.subnet_az[count.index]}"
    SubnetId    = local.subnet_id[count.index]
    App         = "refractr"
    Environment = "prod"
    Terraform   = "true"
  }
}
