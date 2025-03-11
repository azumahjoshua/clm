#!/bin/bash
set -e

# Run Laravel migrations (optional)
php artisan migrate --force

# Clear cache (optional)
php artisan config:cache
php artisan route:cache

# Start Laravel's built-in server
exec php artisan serve --host=0.0.0.0 --port=8000