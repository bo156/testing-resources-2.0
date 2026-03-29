resource "aws_s3_bucket" "bad_bucket" {
  bucket = "bad_bucket"
}


resource "aws_s3_bucket" "bad_bucket_log_bucket" {
  bucket = "bad_bucket-log-bucket"
}

resource "aws_s3_bucket_logging" "bad_bucket" {
  bucket = aws_s3_bucket.bad_bucket.id

  target_bucket = aws_s3_bucket.bad_bucket_log_bucket.id
  target_prefix = "log/"
}


resource "aws_s3_bucket_versioning" "bad_bucket" {
  bucket = aws_s3_bucket.bad_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_versioning" "bad_bucket" {
  bucket = aws_s3_bucket.bad_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "bad_bucket_destination" {
  # checkov:skip=CKV_AWS_144:the resource is auto generated to be a destination for replication
  bucket = aws_s3_bucket.bad_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "bad_bucket_replication" {
  name = "aws-iam-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_replication_configuration" "bad_bucket" {
  depends_on = [aws_s3_bucket_versioning.bad_bucket]
  role   = aws_iam_role.bad_bucket_replication.arn
  bucket = aws_s3_bucket.bad_bucket.id
  rule {
    id = "foobar"
    status = "Enabled"
    destination {
      bucket        = aws_s3_bucket.bad_bucket_destination.arn
      storage_class = "STANDARD"
    }
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "bad_bucket" {
  bucket = aws_s3_bucket.bad_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "bad_acl" {
  bucket = aws_s3_bucket.bad_bucket.id
  acl    = "public-read-write"
}