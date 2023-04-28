resource "aws_s3_bucket" "main" {
  bucket = "${local.namespace}-${random_id.id.hex}-tiflash"
  force_destroy = true
}
