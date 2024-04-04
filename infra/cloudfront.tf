resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    # domain_name = "${var.website_bucket_name}.s3-website-${var.aws_region}.amazonaws.com"
    # origin_id   = var.website_bucket_name

    # custom_origin_config {
    #   http_port              = 80
    #   https_port             = 443
    #   origin_protocol_policy = "http-only"
    #   origin_ssl_protocols   = ["TLSv1.2"]
    #   origin_keepalive_timeout = 5
    #   origin_read_timeout = 30
    # }

    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = var.website_bucket_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
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

    function_association {
      event_type = "viewer-request"
      function_arn = aws_cloudfront_function.index.arn
    }

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  # custom_error_response {
  #   error_caching_min_ttl = 0
  #   error_code = 403
  #   response_code = 200
  #   response_page_path = "/index.html"
  # }

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

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "CloudFront S3 OAC"
  description                       = "Cloud Front S3 OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_function" "index" {
  name = "index"
  runtime = "cloudfront-js-2.0"
  code = file("${path.module}/index.js")
}