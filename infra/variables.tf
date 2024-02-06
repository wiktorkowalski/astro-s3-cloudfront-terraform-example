variable "dns_zone_name" {
  description = "The Route 53 zone name"
  type        = string
}

variable "main_domain_name" {
  description = "The main domain name"
  type        = string
}

variable "domain_aliases" {
  description = "The domain aliases"
  nullable    = true
  type        = list(string)
  default     = []
}

variable "website_bucket_name" {
  description = "The name of the S3 bucket for the website"
  type        = string
}

variable "aws_region" {
  description = "Main AWS region"
  type        = string
}
