output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id  # ✅ Use private_subnets instead of private
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id  # ✅ Use public_subnets instead of public
}
output "vpc_id" {
  value = aws_vpc.main.id  # ✅ Ensure this matches `main.tf`
}
