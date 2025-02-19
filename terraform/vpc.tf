module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.6.0" # ✅ Ensure you use a stable version

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"] # ✅ Update with your availability zones
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_nat_gateway = true # ✅ Allows private subnets to access the internet
  single_nat_gateway = true # ✅ Optimizes cost by using a single NAT Gateway
  enable_vpn_gateway = false

  tags = {
    Name        = "eks-vpc"
    Environment = "Production"
  }
}

