#!/bin/sh

set -e

# # Function to check if a specific table is empty
# check_if_table_is_empty() {
#   if [ "$DB_CONNECTION" = "pgsql" ]; then
#     export PGPASSWORD="$DB_PASSWORD"
#     COUNT=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME" -d "$DB_DATABASE" -t -c "SELECT COUNT(*) FROM migrations;" 2>/dev/null)
#     COUNT=${COUNT:-0}  # Default to 0 if COUNT is empty
#   else
#     echo "Unsupported database connection: $DB_CONNECTION"
#     exit 1
#   fi

#   if [ "$COUNT" -eq 0 ]; then
#     return 0  # Table is empty
#   else
#     return 1  # Table is not empty
#   fi
# }

# echo "🔍 Debugging Environment Variables:"
# echo "DB_CONNECTION: $DB_CONNECTION"
# echo "DB_HOST: $DB_HOST"
# echo "DB_PORT: $DB_PORT"
# echo "DB_DATABASE: $DB_DATABASE"
# echo "DB_USERNAME: $DB_USERNAME"
# echo "DB_PASSWORD: ******"

echo "Waiting for database connection..."
MAX_RETRIES=30
RETRY_INTERVAL=1
count=0

echo "Waiting for database..."
until nc -z "$DB_HOST" "$DB_PORT"; do
  count=$((count + 1))
  if [ $count -ge $MAX_RETRIES ]; then
    echo "Database connection failed after $MAX_RETRIES retries. Exiting."
    exit 1
  fi
  echo "Database not ready, retrying in $RETRY_INTERVAL second(s)..."
  sleep $RETRY_INTERVAL
done
echo "Database is ready!"

# # Run migrations and seed only if needed
# if check_if_table_is_empty || [ "$FORCE_MIGRATE" = "true" ]; then
#   echo "Running migrations and seeding database..."
#   if ! php artisan migrate --seed; then
#     echo "Migration failed. Exiting."
#     exit 1
#   fi
# else
#   echo "Database already contains data. Skipping migration and seeding."
# fi

# # Run Laravel optimizations in production
# if [ "$APP_ENV" = "production" ]; then
#   echo "Caching configuration and routes..."
#   php artisan config:cache
#   php artisan route:cache
# fi

# ls -l /var/www/artisan

# Run migrations
echo "Running database migrations..."
php artisan migrate --force

# Optimize Laravel for production
echo "⚡ Caching Laravel configuration and routes..."
php artisan config:cache
php artisan route:cache

# Run PHP-FPM as the default process
exec "$@"
