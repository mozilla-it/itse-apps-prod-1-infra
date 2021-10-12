# These resources support a cross-Web SRE place to store backups.
# These backups, like for SubHub, are pulled from AWS Accounts or services that have been decommissioned,
# but we wanted to keep some artifact(s) around in case.

resource "aws_s3_bucket" "backups" {
  bucket = "websre-backups"
  acl    = "private"

  lifecycle_rule {
    id      = "purge_tombstone"
    enabled = true
    prefix  = "tombstone/"

    expiration {
      days = 30
    }
  }
}
