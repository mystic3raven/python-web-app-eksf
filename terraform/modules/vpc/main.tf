resource "aws_vpc" "main" {  # Ensure resource name is "main"
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)

  vpc_id     = aws_vpc.main.id  # Reference "main" instead of "this"
  cidr_block = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)

  vpc_id     = aws_vpc.main.id  # Reference "main" instead of "this"
  cidr_block = element(var.public_subnet_cidrs, count.index)

  tags = {
    Name = "public-subnet-${count.index}"
  }
}
