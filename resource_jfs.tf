resource "aws_elasticache_subnet_group" "main" {
  name       = "${local.namespace}-${random_id.id.hex}-cache-subnet"
  subnet_ids = ["${aws_subnet.main.id}"]
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id          = "${local.namespace}-${random_id.id.hex}-group-1"
  replication_group_description = "Redis for JFS"

  node_type            = "cache.r6g.large"
  port                 = 6379
  parameter_group_name = "default.redis7"

  snapshot_retention_limit = 5
  snapshot_window          = "00:00-05:00"

  subnet_group_name          = "${aws_elasticache_subnet_group.main.name}"
  security_group_ids         = ["${aws_security_group.ssh.id}"]
  automatic_failover_enabled = false
}

resource "aws_s3_bucket" "main" {
  bucket = "${local.namespace}-${random_id.id.hex}-tiflash"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}
