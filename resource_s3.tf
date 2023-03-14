resource "aws_s3_bucket" "main" {
  bucket = "${local.namespace}-${random_id.id.hex}-tiflash"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}
