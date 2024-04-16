terraform {
  # Replace with your backend or use local
  backend "s3" {
    bucket = "wiktorkowalski-terraform-state"
    key    = "astro-s3-cloudfront-terraform-example/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "wiktorkowalski-terraform-state"
    encrypt = true
  }
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.45.0"
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