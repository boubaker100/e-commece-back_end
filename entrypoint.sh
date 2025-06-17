#!/bin/sh

# إنشاء مجلدات Laravel المهمة
mkdir -p storage/framework/{sessions,views,cache} bootstrap/cache

# إعطاء الصلاحيات
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# انتظار قاعدة البيانات
until nc -z "$DB_HOST" "$DB_PORT"; do
  echo "⏳ في انتظار قاعدة البيانات على $DB_HOST:$DB_PORT ..."
  sleep 2
done

# التهجير
php artisan migrate --force

echo "✅ قاعدة البيانات جاهزة، جاري تشغيل الخادم..."

# تشغيل Apache
exec apache2-foreground
