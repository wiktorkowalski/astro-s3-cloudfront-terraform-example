resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = "${var.website_bucket_name}.s3-website-${var.aws_region}.amazonaws.com"
    origin_id   = var.website_bucket_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      origin_keepalive_timeout = 5
      origin_read_timeout = 30
    }

    # domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    # origin_id   = var.website_bucket_name
    # s3_origin_config {
    #   origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    # }
  }

  enabled             = true
  default_root_object = "index.html"

  aliases = concat(var.domain_aliases, [var.main_domain_name])

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.website_bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "CF origin identity"
}
