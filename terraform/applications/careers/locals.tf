locals {
  environment            = "prod"
  project                = "careers"
  project_desc           = "careers prod deployment"
  project_email          = "it-sre@mozilla.com"
  region                 = "us-west-2"
  psql_instance          = "db.t3.small"
  psql_storage_allocated = 30
  psql_storage_max       = 100
  psql_version           = "10.17"
  psql_multiaz           = true

  # s3/static site config
  bucket_name         = "mozilla-careers-prod-783633885093"
  s3_website_domain   = "s3-website-us-west-2.amazonaws.com"
  s3_website_endpoint = "${local.bucket_name}.${local.s3_website_domain}"
  s3_zone             = "Z3BJ6K6RIION7M" # this is a magical s3 zone

  domain_name               = "careers.prod.mozit.cloud"
  subject_alternative_names = ["*.mozilla.org"] # wildcard is here to try and do a zero downtime deployment.
  # two cloudfronts cannot exist with the same name, and marketing already owns careers.mozilla.org
  aliases       = concat([local.domain_name], local.subject_alternative_names)
  r53_zone_name = "prod.mozit.cloud."
}
