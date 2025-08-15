#!/bin/sh

cd /var/www/html
set -e

# إنشاء المجلدات المهمة
mkdir -p storage/framework/sessions \
         storage/framework/views \
         storage/framework/cache \
         bootstrap/cache

# إعطاء صلاحيات الكتابة
chmod -R 775 storage bootstrap/cache

# تنظيف الكاش وتحديثه
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# تشغيل المايغريشن والسييدرز معًا
php artisan migrate --seed --force

# توليد مفاتيح Laravel Passport
php artisan passport:keys --force

# تشغيل Laravel
exec php artisan serve --host=0.0.0.0 --port=8000
