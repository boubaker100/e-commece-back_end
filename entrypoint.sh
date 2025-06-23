#!/bin/sh

# Clear caches (اختياري)
php artisan config:clear
php artisan cache:clear
php artisan route:clear

# Generate app key if missing
php artisan key:generate --force

# إنشاء عملاء Passport
php artisan passport:install --force

# Run migrations and seed database
php artisan migrate:fresh --seed --force

# Start the server
php artisan serve --host=0.0.0.0 --port=8000
