#!/bin/bash
set -e

# Print environment variables (excluding sensitive data)
echo "Debugging Environment Variables:"
echo "DB_CONNECTION: $DB_CONNECTION"
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "DB_DATABASE: $DB_DATABASE"
echo "DB_USERNAME: $DB_USERNAME"
echo "DB_PASSWORD: ******"

# Function to check database connectivity
check_database_connection() {
    echo "Waiting for database connection..."
    MAX_RETRIES=30
    RETRY_INTERVAL=1
    count=0

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
}

# Function to run Laravel migrations
run_migrations() {
    php artisan migrate --force
    php artisan config:clear
    php artisan cache:clear
    php artisan key:generate
}

# Function to clear Laravel cache
# clear_cache() {
#     php artisan config:cache
#     php artisan route:cache
# }

# Execute all steps
check_database_connection
run_migrations
# clear_cache

# Start Laravel's built-in server
echo "Starting Laravel application..."
exec php artisan serve --host=0.0.0.0 --port=8000
