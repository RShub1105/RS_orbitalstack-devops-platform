resource "aws_s3_bucket" "firmware" {
  bucket = "orbital-firmware-binaries"
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "firmware" {
  bucket = aws_s3_bucket.firmware.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_lifecycle_configuration" "firmware" {
  bucket = aws_s3_bucket.firmware.id
  rule {
    id     = "delete-old-firmware"
    status = "Enabled"
    expiration { days = 365 }
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "orbital-logs"
  tags   = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    id     = "archive-logs"
    status = "Enabled"
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}

