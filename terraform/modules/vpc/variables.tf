variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "List of private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of public subnets"
  type        = list(string)
}
