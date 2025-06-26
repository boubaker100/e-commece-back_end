#!/bin/sh

# الدخول إلى مجلد المشروع
cd /var/www/html

# إيقاف التنفيذ عند أول خطأ
set -e

# إنشاء المجلدات المهمة في Laravel
mkdir -p storage/framework/sessions \
         storage/framework/views \
         storage/framework/cache \
         bootstrap/cache

# إعطاء صلاحيات الكتابة
chmod -R 775 storage bootstrap/cache

# تنظيف وتحديث الكاش
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# تشغيل المايغريشن
php artisan migrate --force || true

# توليد مفاتيح Laravel Passport
php artisan passport:keys --force || true

# تشغيل Laravel باستخدام php-fpm (وهو ما يستعمله Render داخليًا)

exec php artisan serve --host=0.0.0.0 --port=8000
