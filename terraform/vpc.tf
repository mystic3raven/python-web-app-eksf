mmodule "vpc" {
  source = "./modules/vpc"  # Ensure this directory exists

  vpc_cidr           = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
}
