
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.6.0" # Upgrade to the latest version

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_dns_support   = true
  enable_dns_hostnames = true
}
