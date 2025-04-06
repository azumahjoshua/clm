#!/bin/bash
set -e

# Load environment variables
source /home/ubuntu/app/.env

# Login to ECR Public
aws ecr-public get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin public.ecr.aws

# Pull the latest images
docker compose -f /home/ubuntu/app/docker-compose.yml pull

# Stop and recreate containers
docker compose -f /home/ubuntu/app/docker-compose.yml down --remove-orphans
docker compose -f /home/ubuntu/app/docker-compose.yml up -d

# Clean up old images
docker image prune -af

# Verify deployment
echo "Deployment complete!"
docker ps