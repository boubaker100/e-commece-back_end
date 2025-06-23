#!/bin/sh
cd /var/www

# فقط تشغيل السيرفر، بدون migrations ولا seeding
php artisan serve --host=0.0.0.0 --port=8000 --no-interaction
