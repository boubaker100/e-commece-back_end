#!/bin/sh
cd /var/www

# شغل الخادم فقط
php artisan serve --host=0.0.0.0 --port=8000
