#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Warning message
echo "WARNING: If these resources were created using Terraform, it is highly recommended to use 'terraform destroy' instead of this script to avoid inconsistencies in state files."
read -p "Do you wish to continue? (yes/no): " choice
if [[ "$choice" != "yes" ]]; then
    echo "Exiting script."
    exit 0
fi

# Function to list and delete resources
delete_resources() {
    local resource_type=$1
    local list_command=$2
    local delete_command=$3
    local id_key=$4

    echo "Discovering $resource_type..."
    resource_ids=$(eval "$list_command" | jq -r ".${id_key}[]")

    if [[ -z "$resource_ids" ]]; then
        echo "No $resource_type found."
        return
    fi

    echo "Available $resource_type:"
    echo "$resource_ids" | nl

    echo "Options:"
    echo "1. Delete all"
    echo "2. Delete specific IDs"
    echo "3. Skip"
    read -p "Enter your choice: " option

    case $option in
        1)
            echo "Deleting all $resource_type..."
            for id in $resource_ids; do
                echo "Deleting $resource_type $id..."
                eval "$delete_command $id" || echo "Failed to delete $id."
            done
            ;;
        2)
            read -p "Enter the line numbers of IDs to delete (comma-separated): " lines
            IFS=',' read -ra selected_lines <<< "$lines"
            for line in "${selected_lines[@]}"; do
                id=$(echo "$resource_ids" | sed -n "${line}p")
                echo "Deleting $resource_type $id..."
                eval "$delete_command $id" || echo "Failed to delete $id."
            done
            ;;
        3)
            echo "Skipping $resource_type."
            ;;
        *)
            echo "Invalid option. Skipping $resource_type."
            ;;
    esac
}

# Delete subnets
delete_resources "subnets" \
    "aws ec2 describe-subnets --query 'Subnets[*].SubnetId'" \
    "aws ec2 delete-subnet --subnet-id" \
    "Subnets[*].SubnetId"

# Delete route tables
delete_resources "route tables" \
    "aws ec2 describe-route-tables --query 'RouteTables[*].RouteTableId'" \
    "aws ec2 delete-route-table --route-table-id" \
    "RouteTables[*].RouteTableId"

# Release Elastic IPs
delete_resources "Elastic IPs" \
    "aws ec2 describe-addresses --query 'Addresses[*].AllocationId'" \
    "aws ec2 release-address --allocation-id" \
    "Addresses[*].AllocationId"

# Delete security groups
delete_resources "security groups" \
    "aws ec2 describe-security-groups --query 'SecurityGroups[*].GroupId'" \
    "aws ec2 delete-security-group --group-id" \
    "SecurityGroups[*].GroupId"

echo "Cleanup complete!"
