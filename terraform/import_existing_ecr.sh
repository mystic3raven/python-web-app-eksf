#!/bin/bash

ECR_NAME="python-web-app-eksf"

# Check if ECR repository exists
if aws ecr describe-repositories --repository-names "$ECR_NAME" >/dev/null 2>&1; then
    echo "ECR repository '$ECR_NAME' exists. Importing into Terraform..."
    terraform import aws_ecr_repository.python_web_app "$ECR_NAME" || echo "⚠️ Import failed or already exists in Terraform state."
else
    echo "ECR repository '$ECR_NAME' does not exist. Terraform will create it."
fi

# Run Terraform
terraform init
terraform plan
terraform apply -auto-approve
