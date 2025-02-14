variable "aws_region" {
  description = "AWS Region"
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  default     = "python-web-app-cluster"
}

variable "ecr_repo_name" {
  description = "ECR Repository Name"
  default     = "python-web-app"
}

variable "instance_type" {
  description = "EC2 Instance type for EKS nodes"
  default     = "t3.medium"
}

variable "node_count" {
  description = "Number of worker nodes"
  default     = 2
}
