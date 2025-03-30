#!/bin/bash

# Exit immediately if any command fails
set -e

echo "Destroying Terraform infrastructure..."

# Initialize Terraform if not already initialized
terraform init -upgrade

# Destroy the infrastructure
terraform destroy -auto-approve

echo "Terraform infrastructure destroyed successfully!"
