#!/bin/sh

# تأكد من وجود مجلدات Laravel المهمة
mkdir -p storage/framework/{cache,sessions,views} bootstrap/cache

# إعطاء الصلاحيات
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# انتظار قاعدة البيانات
until nc -z "$DB_HOST" "$DB_PORT"; do
  echo "⏳ في انتظار قاعدة البيانات على $DB_HOST:$DB_PORT ..."
  sleep 2
done

# تهجير القاعدة
php artisan migrate --force || exit 1

echo "✅ قاعدة البيانات جاهزة، جاري تشغيل الخادم..."

# بدء Apache
apache2-foreground
