#!/bin/bash
set -e

# Deployment directory
DEPLOY_DIR="/home/ubuntu/app"

# Load environment variables
if [ -f "$DEPLOY_DIR/back-end/.env" ]; then
  echo "Loading backend environment variables..."
  source "$DEPLOY_DIR/back-end/.env"
else
  echo "Error: Backend .env file not found at $DEPLOY_DIR/back-end/.env"
  exit 1
fi

if [ -f "$DEPLOY_DIR/front-end/.env" ]; then
  echo "Loading frontend environment variables..."
  source "$DEPLOY_DIR/front-end/.env"
else
  echo "Warning: Frontend .env file not found at $DEPLOY_DIR/front-end/.env"
fi

# Verify critical backend variables
REQUIRED_BACKEND_VARS=("DB_HOST" "DB_DATABASE" "DB_USERNAME" "DB_PASSWORD")
for var in "${REQUIRED_BACKEND_VARS[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Error: Required backend variable $var is not set"
    exit 1
  fi
done

# Login to ECR Public
echo "Authenticating with ECR..."
aws ecr-public get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin public.ecr.aws || {
  echo "Error: ECR login failed"
  exit 1
}

# Pull the latest images
echo "Pulling latest Docker images..."
docker compose -f "$DEPLOY_DIR/docker-compose.yml" pull || {
  echo "Error: Failed to pull Docker images"
  exit 1
}

# Stop and recreate containers
echo "Restarting containers..."
docker compose -f "$DEPLOY_DIR/docker-compose.yml" down --remove-orphans --timeout 30 || {
  echo "Error: Failed to stop old containers"
  exit 1
}

docker compose -f "$DEPLOY_DIR/docker-compose.yml" up -d --wait || {
  echo "Error: Failed to start new containers"
  exit 1
}

# Clean up old images
echo "Cleaning up old images..."
docker image prune -af || {
  echo "Warning: Image pruning failed"
}

# Verify deployment
echo "Verifying deployment..."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Additional health checks
echo "Running health checks..."
docker compose -f "$DEPLOY_DIR/docker-compose.yml" ps --services | while read service; do
  if ! docker compose -f "$DEPLOY_DIR/docker-compose.yml" ps -q "$service" | xargs docker inspect -f '{{.State.Status}}' | grep -q 'running'; then
    echo "Error: Service $service is not running"
    docker compose -f "$DEPLOY_DIR/docker-compose.yml" logs "$service"
    exit 1
  fi
done

echo "Deployment completed successfully!"