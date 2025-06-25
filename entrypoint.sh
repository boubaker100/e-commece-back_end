#!/bin/sh

#
php artisan config:clear
#

php artisan migrate:fresh --force
php artisan passport:install --force

php artisan db:seed --force



exec "$@"

