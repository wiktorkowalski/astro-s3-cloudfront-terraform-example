resource "aws_s3_bucket" "website_bucket" {
  bucket = var.website_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"

  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "website_bucket" {
  depends_on = [ 
    aws_s3_bucket_public_access_block.website_bucket,
    aws_s3_bucket_ownership_controls.website_bucket
  ]

  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontS3Access"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::${var.website_bucket_name}",
      "arn:aws:s3:::${var.website_bucket_name}/*",
    ]

    actions = ["s3:GetObject"]

    # principals {
    #   type        = "AWS"
    #   identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    # }

    # condition {
    #   test     = "StringEquals"
    #   variable = "AWS:SourceArn"
    #   values   = [aws_cloudfront_distribution.website_distribution.arn]
    # }

    # principals {
    #   type        = "Service"
    #   identifiers = ["cloudfront.amazonaws.com"]
    # }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}