#!/bin/bash

# Laravel commands
php artisan config:clear
php artisan key:generate
php artisan migrate --force || true
php artisan config:cache
php artisan route:cache
php artisan view:cache

# تنفيذ التهجير + seeder مرّة واحدة عند التشغيل
php artisan migrate --seed --force

# Start Laravel server
php artisan serve --host=0.0.0.0 --port=8000
