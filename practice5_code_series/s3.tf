# pipeline s3
resource "aws_s3_bucket" "pipeline_bucket" {
  bucket = var.s3_name
  force_destroy = true

  tags = {
    bucket = var.s3_name
  }
}

resource "aws_s3_bucket_acl" "pipeline_bucket_acl" {
  bucket = aws_s3_bucket.pipeline_bucket.id
  acl    = "private"
}