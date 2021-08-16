resource "aws_db_instance" "discourse" {
  identifier                  = "discourse-${var.environment}"
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = var.psql_version
  instance_class              = var.psql_instance
  allocated_storage           = var.psql_storage_allocated
  max_allocated_storage       = var.psql_storage_max
  multi_az                    = var.environment == "prod" ? true : false
  allow_major_version_upgrade = true
  name                        = "discourse"
  username                    = "discourse"
  backup_retention_period     = 15
  db_subnet_group_name        = aws_db_subnet_group.discourse-db.id
  vpc_security_group_ids      = [aws_security_group.discourse-db.id]
}

resource "aws_db_subnet_group" "discourse-db" {
  name        = "discourse-${var.environment}-db"
  description = "Subnet for discourse ${var.environment} DB"
  subnet_ids  = flatten([data.terraform_remote_state.vpc.outputs.private_subnets])
}

resource "aws_security_group" "discourse-db" {
  name   = "discourse-${var.environment}-db"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = ["172.16.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "rds_endpoint" {
  value = aws_db_instance.discourse.endpoint
}
