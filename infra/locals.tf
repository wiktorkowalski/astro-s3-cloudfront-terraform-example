locals {
    # REMEMBER TO CHANGE THIS TO YOUR OWN DOMAIN NAMES
    dns_zone_name = "wiktorkowalski.pl"
    main_domain_name = "example.wiktorkowalski.pl"
    domain_aliases = ["subdomain.example.wiktorkowalski.pl", "another.example.wiktorkowalski.pl"]
    website_bucket_name = "example-website"
    aws_region = "eu-west-1"
}