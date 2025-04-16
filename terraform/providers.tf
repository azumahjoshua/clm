terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Default AWS provider
provider "aws" {
  region = "us-east-1"
}

# Alias for ECR public provider
provider "aws" {
  alias  = "ecr-public"
  region = "us-east-1"
}