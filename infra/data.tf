# import existing aws route 53 zone
data "aws_route53_zone" "dns_zone" {
  name = var.dns_zone_name
}