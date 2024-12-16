#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Delete Subnets
echo "Deleting Subnets..."
subnets=("subnet-0822693587de557d0" "subnet-0c1c732cc1c74f1c3" "subnet-052f1caf1cdd845d1" "subnet-07b8b00c52e7b1a79" "subnet-04918e177b3026490" "subnet-07d20277c641bd83e" "subnet-0fceb2e67ac082f4e" "subnet-057b0ef4df80b1d30")
for subnet in "${subnets[@]}"; do
    echo "Deleting subnet $subnet..."
    aws ec2 delete-subnet --subnet-id $subnet || echo "Failed to delete $subnet. It may be in use or already deleted."
done

# Delete Route Tables
echo "Deleting Route Tables..."
route_tables=("rtb-04516aa95ca412c17" "rtb-04737ecdd28670e4f" "rtb-066f0b06c9c9356bd" "rtb-09aa58538a03a4b2c" "rtb-096ede1762c1e4db7" "rtb-09fcc2198eceb3625" "rtb-061ca078192ae7cfa" "rtb-0d91f39a42cc95dc3" "rtb-0714889bae3bd0a84")
for rt in "${route_tables[@]}"; do
    echo "Deleting route table $rt..."
    aws ec2 delete-route-table --route-table-id $rt || echo "Failed to delete $rt. It may be in use or already deleted."
done

# Release Elastic IPs
echo "Releasing Elastic IPs..."
eips=("eipalloc-0b6d8bc065eced452" "eipalloc-095fea254dd947c48")
for eip in "${eips[@]}"; do
    echo "Releasing Elastic IP $eip..."
    aws ec2 release-address --allocation-id $eip || echo "Failed to release $eip. It may already be released."
done

# Delete Security Groups
echo "Deleting Security Groups..."
security_groups=("sg-0c824be8132311f41" "sg-06325abd8174f4159" "sg-0d4e1502eacb52941" "sg-00636503c9f332f5c")
for sg in "${security_groups[@]}"; do
    echo "Deleting security group $sg..."
    aws ec2 delete-security-group --group-id $sg || echo "Failed to delete $sg. It may be in use or already deleted."
done

echo "Cleanup complete!"

