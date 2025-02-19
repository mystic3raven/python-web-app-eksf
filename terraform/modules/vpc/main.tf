resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id     = aws_vpc.this.id
  cidr_block = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id     = aws_vpc.this.id
  cidr_block = element(var.public_subnet_cidrs, count.index)

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

