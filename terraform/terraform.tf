terraform {

  backend "s3" {
    bucket         = "strix-tf-state-v1"  # From bootstrap output
    key            = "strix/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "strix-terraform-locks"                      # From bootstrap output
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}
