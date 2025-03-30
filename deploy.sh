#!/bin/bash

# Exit script on error
set -e

# Define variables
TF_DIR="./terraform"  
LOG_FILE="terraform_deploy.log"

# Function to log output
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") | $1" | tee -a $LOG_FILE
}

log "Starting Terraform deployment..."

# Change to Terraform directory
cd "$TF_DIR" || { log "Terraform directory not found!"; exit 1; }

# Initialize Terraform
log "Initializing Terraform..."
terraform init | tee -a $LOG_FILE

# Validate Terraform configuration
log "Validating Terraform..."
terraform validate | tee -a $LOG_FILE

# Generate execution plan
log "Generating Terraform plan..."
terraform plan -out=tfplan | tee -a $LOG_FILE

# Ask for confirmation before applying
read -p "Do you want to apply these changes? (yes/no): " CONFIRM
if [[ "$CONFIRM" == "yes" ]]; then
    log "Applying Terraform changes..."
    terraform apply "tfplan" | tee -a $LOG_FILE
    log "Terraform deployment successful!"
else
    log "Deployment canceled by user."
    exit 0
fi
