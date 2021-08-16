resource "aws_elasticache_cluster" "discourse" {
  cluster_id           = "discourse-${var.environment}"
  engine               = "redis"
  node_type            = var.redis_instance
  num_cache_nodes      = var.redis_num_nodes
  engine_version       = var.redis_version
  parameter_group_name = "default.redis5.0"
  subnet_group_name    = aws_elasticache_subnet_group.discourse-redis.id
  security_group_ids   = [aws_security_group.discourse-redis.id]
}

resource "aws_elasticache_subnet_group" "discourse-redis" {
  name        = "discourse-${var.environment}-redis"
  description = "Subnet for discourse ${var.environment} Redis cluster"
  subnet_ids  = flatten([data.terraform_remote_state.vpc.outputs.private_subnets])
}

resource "aws_security_group" "discourse-redis" {
  name   = "discourse-${var.environment}-redis"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
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
