terraform {
  required_version = "1.13.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # Use the latest 6.x (6.1 to 6.9) version of the AWS provider.
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0" # Use the latest 3.x (3.1 to 3.9) version of the Random provider.
    }

  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      repo         = "August-Terraform"
      organization = "livingdevops"
      team         = "august bootcamp"
      Terraform    = "true"
    }
  }
}

# Configure remote state storage in S3
terraform {
  backend "s3" {

  }
}