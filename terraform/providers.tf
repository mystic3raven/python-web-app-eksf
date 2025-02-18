provider "aws" {
  region = "us-west-2" # Change based on your region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
  #backend "s3" {
  #  bucket = "my-terraform-state-bucket"
  #  key    = "eks-fargate/terraform.tfstate"
  #  region = "us-west-2"
  #}
}
