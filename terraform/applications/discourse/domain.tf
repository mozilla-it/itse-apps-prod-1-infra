# discourse.prod.mozit.cloud
# -> lb, k8s via external-dns

# discourse.mozilla.org
# -> email / SES setup via terraform
# -> lb, k8s via external-dns

# Would use the following for consistency, but requires creation of new delegation set
# which will cause a short outage for production discourse (to update DNS records)
# module "discourse_mozilla" {
#   source = "github.com/mozilla-it/terraform-modules//aws/dns/apex?ref=master"
#   domain = var.discourse_mozilla
# }

resource "aws_route53_zone" "discourse" {
  name          = "${var.discourse_mozilla}."
  force_destroy = "false"
}

resource "aws_route53_record" "zone_ns" {
  zone_id = aws_route53_zone.discourse.zone_id
  name    = var.discourse_mozilla
  type    = "NS"
  ttl     = "172800"

  records = [
    aws_route53_zone.discourse.name_servers[0],
    aws_route53_zone.discourse.name_servers[1],
    aws_route53_zone.discourse.name_servers[2],
    aws_route53_zone.discourse.name_servers[3],
  ]
}
