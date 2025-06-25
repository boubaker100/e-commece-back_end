#!/bin/sh

php artisan config:clear
php artisan migrate:fresh --force
php artisan passport:install --force
php artisan db:seed --force

exec php artisan serve --host=0.0.0.0 --port=8000
