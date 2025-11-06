#!/bin/sh

cd /var/www/html
set -e

# إنشاء المجلدات الضرورية
mkdir -p storage/framework/sessions \
         storage/framework/views \
         storage/framework/cache \
         bootstrap/cache

chmod -R 775 storage bootstrap/cache

# تنظيف الكاش
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# تشغيل المايغريشن والسييد
php artisan migrate --force || true
php artisan db:seed --force || true

# توليد مفاتيح Laravel Passport
php artisan passport:keys --force || true

# تشغيل السيرفر
exec php artisan serve --host=0.0.0.0 --port=8000
