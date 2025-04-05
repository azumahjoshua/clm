#!/bin/bash
set -e

# Run Laravel migrations (optional)
php artisan migrate --force

# Clear cache (optional)
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Start Laravel's built-in server
exec php artisan serve --host=0.0.0.0 --port=8000