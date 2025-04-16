#!/bin/bash
set -e

DEPLOY_DIR="/home/ubuntu/app"

# Load .env files
echo "Loading environment variables..."

BACK_ENV="$DEPLOY_DIR/back-end/.env"
FRONT_ENV="$DEPLOY_DIR/front-end/.env"

if [ -f "$BACK_ENV" ]; then
  source "$BACK_ENV"
else
  echo "Backend .env file not found at $BACK_ENV"
  exit 1
fi

if [ -f "$FRONT_ENV" ]; then
  source "$FRONT_ENV"
else
  echo "Frontend .env file not found at $FRONT_ENV"
fi

# Check required backend variables
REQUIRED_VARS=("DB_HOST" "DB_DATABASE" "DB_USERNAME" "DB_PASSWORD")
for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    echo "Missing required backend env var: $VAR"
    exit 1
  fi
done

# Docker login to ECR
echo "Logging in to ECR Public..."
aws ecr-public get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin public.ecr.aws || {
  echo "ECR login failed"
  exit 1
}

# Pull, stop old, start new containers
echo "Pulling latest Docker images..."
docker compose -f "$DEPLOY_DIR/docker-compose.yml" pull

echo "Shutting down old containers..."
docker compose -f "$DEPLOY_DIR/docker-compose.yml" down --remove-orphans --timeout 30

echo "Starting new containers..."
docker compose -f "$DEPLOY_DIR/docker-compose.yml" up -d --wait

# Prune old images
echo "Cleaning up unused Docker images..."
docker image prune -af || echo "Warning: Image prune failed"

# Health checks
echo "Verifying running containers..."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo "Running container health checks..."
docker compose -f "$DEPLOY_DIR/docker-compose.yml" ps --services | while read service; do
  STATUS=$(docker compose -f "$DEPLOY_DIR/docker-compose.yml" ps -q "$service" | xargs docker inspect -f '{{.State.Status}}')
  if [[ "$STATUS" != "running" ]]; then
    echo "Service $service is not running"
    docker compose -f "$DEPLOY_DIR/docker-compose.yml" logs "$service"
    exit 1
  fi
done

echo "Deployment successful."

# #!/bin/bash
# set -e

# # Deployment directory
# DEPLOY_DIR="/home/ubuntu/app"

# # Load environment variables
# if [ -f "$DEPLOY_DIR/back-end/.env" ]; then
#   echo "Loading backend environment variables..."
#   source "$DEPLOY_DIR/back-end/.env"
# else
#   echo "Error: Backend .env file not found at $DEPLOY_DIR/back-end/.env"
#   exit 1
# fi

# if [ -f "$DEPLOY_DIR/front-end/.env" ]; then
#   echo "Loading frontend environment variables..."
#   source "$DEPLOY_DIR/front-end/.env"
# else
#   echo "Warning: Frontend .env file not found at $DEPLOY_DIR/front-end/.env"
# fi

# # Verify critical backend variables
# REQUIRED_BACKEND_VARS=("DB_HOST" "DB_DATABASE" "DB_USERNAME" "DB_PASSWORD")
# for var in "${REQUIRED_BACKEND_VARS[@]}"; do
#   if [ -z "${!var}" ]; then
#     echo "Error: Required backend variable $var is not set"
#     exit 1
#   fi
# done

# # Login to ECR Public
# echo "Authenticating with ECR..."
# aws ecr-public get-login-password --region us-east-1 | \
#   docker login --username AWS --password-stdin public.ecr.aws || {
#   echo "Error: ECR login failed"
#   exit 1
# }

# # Pull the latest images
# echo "Pulling latest Docker images..."
# docker compose -f "$DEPLOY_DIR/docker-compose.yml" pull || {
#   echo "Error: Failed to pull Docker images"
#   exit 1
# }

# # Stop and recreate containers
# echo "Restarting containers..."
# docker compose -f "$DEPLOY_DIR/docker-compose.yml" down --remove-orphans --timeout 30 || {
#   echo "Error: Failed to stop old containers"
#   exit 1
# }

# docker compose -f "$DEPLOY_DIR/docker-compose.yml" up -d --wait || {
#   echo "Error: Failed to start new containers"
#   exit 1
# }

# # Clean up old images
# echo "Cleaning up old images..."
# docker image prune -af || {
#   echo "Warning: Image pruning failed"
# }

# # Verify deployment
# echo "Verifying deployment..."
# docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# # Additional health checks
# echo "Running health checks..."
# docker compose -f "$DEPLOY_DIR/docker-compose.yml" ps --services | while read service; do
#   if ! docker compose -f "$DEPLOY_DIR/docker-compose.yml" ps -q "$service" | xargs docker inspect -f '{{.State.Status}}' | grep -q 'running'; then
#     echo "Error: Service $service is not running"
#     docker compose -f "$DEPLOY_DIR/docker-compose.yml" logs "$service"
#     exit 1
#   fi
# done

# echo "Deployment completed successfully!"