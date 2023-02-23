locals {
  cluster_features = {
    "aws_calico"         = false
    "external_secrets"   = true
    "fluentd_papertrail" = true
    "flux"               = false
    "flux_helm_operator" = false
    "prometheus"         = true
    "configmapsecrets"   = true
  }

  external_secrets_settings = {}

  fluentd_papertrail_settings = {
    "externalSecrets.secretsKey" = "/prod/${module.itse-apps-prod-1.cluster_id}-papertrail"
  }

  flux_settings = {
    "git.url"    = "git@github.com:mozilla-it/itse-apps-prod-1-infra"
    "git.branch" = "main"
  }

  node_groups = {
    blue_node_group = {
      release_version  = "1.20.15-20220629"
      desired_capacity = 10,
      disk_size        = 120,
      instance_types   = ["m5.large"],
      max_capacity     = 20,
      min_capacity     = 5,
      subnets          = data.terraform_remote_state.vpc.outputs.private_subnets
    }
  }

  subnet_az = [for s in data.aws_subnet.public : s.availability_zone]
  subnet_id = [for s in data.aws_subnet.public : s.id]
}

module "itse-apps-prod-1" {
  source                      = "github.com/mozilla-it/terraform-modules//aws/eks?ref=master"
  cluster_name                = "itse-apps-prod-1"
  admin_users_arn             = ["arn:aws:iam::783633885093:role/maws-admin", "arn:aws:iam::517826968395:role/itsre-admin"]
  cluster_features            = local.cluster_features
  cluster_subnets             = data.terraform_remote_state.vpc.outputs.public_subnets
  cluster_version             = "1.21"
  enable_logging              = true
  external_secrets_settings   = local.external_secrets_settings
  external_secrets_prefixes   = ["/prod/*"]
  fluentd_papertrail_settings = local.fluentd_papertrail_settings
  flux_settings               = local.flux_settings
  node_groups                 = local.node_groups
  vpc_id                      = data.terraform_remote_state.vpc.outputs.vpc_id
  prometheus_settings = {
    "server.persistentVolume.size" : "50Gi"
  }
  prometheus_customization_settings = {
    "influxdb.enabled" : "true"
    "influxdb.secret_key" : "/prod/influxdb/prod"
  }
  influxdb = true
}

# Chicken and egg issue, this needs to exist first
# before we can create the refractr ingress-nginx
resource "aws_eip" "refractr_eip" {
  count = length(local.subnet_az)
  vpc   = true

  tags = {
    Name     = "refractr-prod-${local.subnet_az[count.index]}"
    SubnetId = local.subnet_id[count.index]
    App      = "refractr"
  }
}

# Uncertain if we still *need* this domain
# but migrating it here from itsre apps repo
resource "aws_route53_delegation_set" "delegation_set" {
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "mozilla-redirects" {
  name = "mozilla-redirects.xyz"

  delegation_set_id = aws_route53_delegation_set.delegation_set.id

  tags = {
    Name      = "mozilla-redirects.xyz"
    Purpose   = "mozilla redirects master zone"
    Terraform = "true"
  }
}

