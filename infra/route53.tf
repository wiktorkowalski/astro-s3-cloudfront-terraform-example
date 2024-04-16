resource "aws_route53_record" "url" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = var.main_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "domain_aliases" {
  count   = length(var.domain_aliases)
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = var.domain_aliases[count.index]
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# import existing aws route 53 zone
data "aws_route53_zone" "dns_zone" {
  name = var.dns_zone_name
}