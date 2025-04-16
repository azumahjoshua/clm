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
