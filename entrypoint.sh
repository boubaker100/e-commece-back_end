#!/bin/sh

php artisan config:clear
php artisan migrate
exec php artisan serve --host=0.0.0.0 --port=8000
