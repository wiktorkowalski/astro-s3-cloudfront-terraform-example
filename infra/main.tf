terraform {
  backend "s3" {
    bucket = "wiktorkowalski-terraform-state"
    key    = "astro-s3-cloudfront-terraform-example/terraform.tfstate"
    region = var.aws_region
    dynamodb_table = "wiktorkowalski-terraform-state"
    encrypt = true
  }
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.33.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
}

provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
}