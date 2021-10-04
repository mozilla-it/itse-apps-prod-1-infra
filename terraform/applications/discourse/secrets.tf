# Discourse Application Secrets Metadata

resource "aws_secretsmanager_secret" "envvar" {
  name        = "/${var.environment}/discourse/envvar"
  description = "discourse ${var.environment} environment variables as json (see helm chart for expected json)"
}

resource "aws_secretsmanager_secret" "logger" {
  name        = "/${var.environment}/discourse/logger"
  description = "discourse ${var.environment} papertrail logger configuration as json (see helm chart for expected json)"
}
