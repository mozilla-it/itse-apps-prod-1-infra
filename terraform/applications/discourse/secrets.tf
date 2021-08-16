# Discourse Application Secrets Metadata

resource "aws_secretsmanager_secret" "envvar" {
  name        = "/${var.environment}/discourse/envvar"
  description = "discourse ${var.environment} environment variables as json (see helm chart for expected json)"
}
