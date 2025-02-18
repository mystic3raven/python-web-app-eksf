module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "eks-vpc"
  cidr = var.vpc_cidr

  azs                = ["us-east-1a", "us-east-1b"]
  private_subnets    = var.subnet_cidrs
  enable_nat_gateway = true
}
