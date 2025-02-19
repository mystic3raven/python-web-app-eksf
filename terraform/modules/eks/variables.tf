variable "cluster_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "role_arn" {
  type        = string
  description = "ARN of the IAM role for EKS"
}
