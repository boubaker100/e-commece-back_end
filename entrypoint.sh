#!/bin/sh

#
php artisan config:clear
#

php artisan migrate --force
#php artisan passport:install --force
php artisan db:seed --force
exec "$@"

