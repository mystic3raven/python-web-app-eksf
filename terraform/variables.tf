variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  default     = "python-web-app-cluster"
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "Subnet CIDR Blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "developer_role_arn" {
  description = "ARN of the developer role allowed to access EKS"
  default     = "arn:aws:iam::886436961042:role/DeveloperRole"
}
variable "eks_fargate_role_name" {
  description = "IAM Role name for EKS Fargate execution"
  type        = string
  default     = "EKSFargateExecutionRole"
}
variable "eks_user_role_name" {
  description = "IAM Role name for EKS User"
  type        = string
  default     = "EKSUserRole"
}
variable "eks_admin_role_name" {
  description = "IAM Role name for EKS Admin"
  type        = string
  default     = "EKSAdminRole"
}
