#!/bin/sh
cd /var/www

# Clear caches
php artisan config:clear
php artisan cache:clear
php artisan route:clear

# Run migrations (fresh) and seed
php artisan migrate:fresh --force --no-interaction

# Install Passport clients
php artisan passport:install --force --no-interaction

# Seed DB
php artisan db:seed --force --no-interaction

# Start server
php artisan serve --host=0.0.0.0 --port=8000
