variable "cf_cache_compress" {
  default = "true"
  type    = string
}

variable "cf_price_class" {
  default = "PriceClass_100"
  type    = string
}

variable "cost_center" {
  default = "1410"
  type    = string
}

variable "discourse_cdn_zone" {
  default = "discourse-prod.itsre-apps.mozit.cloud"
  type    = string
}

variable "discourse_mozilla" {
  default = "discourse.mozilla.org"
  type    = string
}

variable "environment" {
  default = "prod"
  type    = string
}

variable "project" {
  default = "discourse"
  type    = string
}

variable "project_desc" {
  default = "discourse.mozilla.org"
  type    = string
}

variable "project_email" {
  default = "it-sre@mozilla.com"
  type    = string
}

variable "psql_instance" {
  default = "db.t3.small"
  type    = string
}

variable "psql_storage_allocated" {
  default = 10
  type    = number
}

variable "psql_storage_max" {
  default = 100
  type    = number
}

variable "psql_version" {
  default = "10.15"
  type    = string
}

variable "redis_instance" {
  default = "cache.t2.small"
  type    = string
}

variable "redis_num_nodes" {
  default = 1
  type    = number
}

variable "redis_version" {
  default = "5.0.4"
  type    = string
}

variable "region" {
  default = "us-west-2"
  type    = string
}
