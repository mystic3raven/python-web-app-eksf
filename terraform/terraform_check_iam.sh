#!/bin/bash

ROLE_NAME="EKSUserRole"

# Check if IAM role exists
if aws iam get-role --role-name "$ROLE_NAME" >/dev/null 2>&1; then
    echo "IAM Role '$ROLE_NAME' exists. Importing into Terraform..."
    terraform import aws_iam_role.eks_user_role "$ROLE_NAME" || echo " Import failed or already exists in Terraform state."
else
    echo " IAM Role '$ROLE_NAME' does not exist. Terraform will create it."
fi

# Run Terraform
terraform init
terraform plan
terraform apply -auto-approve
