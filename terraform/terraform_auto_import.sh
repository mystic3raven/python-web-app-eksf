#!/bin/bash

# Set AWS Profile and Region (Modify if needed)
AWS_PROFILE="default"
AWS_REGION="us-west-2"

# List of Terraform resources to import
declare -A RESOURCE_MAP

echo "🔍 Scanning Terraform directory for resources..."

# Extract all Terraform resources from .tf files
while IFS= read -r line; do
    RESOURCE_TYPE=$(echo "$line" | awk '{print $2}')
    RESOURCE_NAME=$(echo "$line" | awk '{print $3}' | tr -d '"')
    RESOURCE_MAP["$RESOURCE_NAME"]=$RESOURCE_TYPE
done < <(grep -E 'resource\s+"aws_[a-zA-Z0-9_]+"\s+"[a-zA-Z0-9_]+"' ./*.tf)

echo "✅ Found ${#RESOURCE_MAP[@]} resources in Terraform configuration."

# Function to check if a resource exists in AWS and import it
import_resource() {
    local RESOURCE_NAME=$1
    local RESOURCE_TYPE=$2
    local AWS_CMD=$3
    local ID_FIELD=$4

    # Check if the AWS resource exists
    RESOURCE_ID=$(eval "$AWS_CMD" | jq -r "$ID_FIELD" 2>/dev/null)

    if [[ -n "$RESOURCE_ID" && "$RESOURCE_ID" != "null" ]]; then
        echo "✅ $RESOURCE_TYPE '$RESOURCE_NAME' exists in AWS. Importing into Terraform..."
        terraform import "$RESOURCE_TYPE.$RESOURCE_NAME" "$RESOURCE_ID" || echo "⚠️ Import failed or already exists."
    else
        echo "⚠️ $RESOURCE_TYPE '$RESOURCE_NAME' does not exist. Terraform will create it."
    fi
}

echo "🔄 Importing existing AWS resources into Terraform..."

# Loop through the resource map and import them if they exist
for RESOURCE_NAME in "${!RESOURCE_MAP[@]}"; do
    RESOURCE_TYPE="${RESOURCE_MAP[$RESOURCE_NAME]}"

    case "$RESOURCE_TYPE" in
    "aws_iam_role")
        import_resource "$RESOURCE_NAME" "$RESOURCE_TYPE" "aws iam get-role --role-name $RESOURCE_NAME" ".Role.RoleName"
        ;;
    "aws_ecr_repository")
        import_resource "$RESOURCE_NAME" "$RESOURCE_TYPE" "aws ecr describe-repositories --repository-names $RESOURCE_NAME" ".repositories[0].repositoryName"
        ;;
    "aws_cloudwatch_log_group")
        import_resource "$RESOURCE_NAME" "$RESOURCE_TYPE" "aws logs describe-log-groups --log-group-name-prefix $RESOURCE_NAME" ".logGroups[0].logGroupName"
        ;;
    "aws_s3_bucket")
        import_resource "$RESOURCE_NAME" "$RESOURCE_TYPE" "aws s3api head-bucket --bucket $RESOURCE_NAME" "$RESOURCE_NAME"
        ;;
    "aws_vpc")
        import_resource "$RESOURCE_NAME" "$RESOURCE_TYPE" "aws ec2 describe-vpcs --filters Name=tag:Name,Values=$RESOURCE_NAME" ".Vpcs[0].VpcId"
        ;;
    "aws_subnet")
        import_resource "$RESOURCE_NAME" "$RESOURCE_TYPE" "aws ec2 describe-subnets --filters Name=tag:Name,Values=$RESOURCE_NAME" ".Subnets[0].SubnetId"
        ;;
    "aws_security_group")
        import_resource "$RESOURCE_NAME" "$RESOURCE_TYPE" "aws ec2 describe-security-groups --filters Name=group-name,Values=$RESOURCE_NAME" ".SecurityGroups[0].GroupId"
        ;;
    "aws_eks_cluster")
        import_resource "$RESOURCE_NAME" "$RESOURCE_TYPE" "aws eks describe-cluster --name $RESOURCE_NAME" ".cluster.name"
        ;;
    *)
        echo "⚠️ Skipping unsupported resource type: $RESOURCE_TYPE"
        ;;
    esac
done

echo "✅ Finished importing existing resources. Running Terraform apply..."

# Run Terraform
terraform init
terraform plan
terraform apply -auto-approve
